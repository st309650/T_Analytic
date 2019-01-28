import 'package:flutter/material.dart';
import 'modal_progress_hud.dart';
import 'second_page.dart';
import 'dart:convert';
import 'user.dart';
import 'stream_data.dart';
import 'channel_data.dart';
import 'searches.dart';
import 'dart:io';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Analytic',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF5b0f48),
          primaryColorLight: Color(0xFF8a3e74),
          primaryColorDark: Color(0xFF300021),
          secondaryHeaderColor: Color(0xFFe30425),
          fontFamily: 'RobotoMono',
          textTheme: TextTheme(display1: TextStyle(fontSize: 24.0, color: Colors.white) ),
          hintColor: Color(0xFF8a3e74)
      ),
      home: new SearchPage(),
    );
  }
}


class SearchPage extends StatefulWidget{
  @override
  _SearchPage createState() => new _SearchPage();
}

class _SearchPage extends State<SearchPage> {

Future<User> user;
Future<StreamData> stream;
Future<ChannelData> channel;

String name;
bool _saving = false;
String errorMessage;

final myController = TextEditingController();

  List<String> inputList(String input) {
    var outList = new List<String>();
    if(input.contains(',')){
      input = input.replaceAll("\\s+","");
      input = input.replaceAll(" ", "");
    }
    final _delimiter = ',';
    final _values = input.split(_delimiter);
    _values.forEach((item) {
      outList.add(item);
    });
    return outList;
  }

  void _showDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Whoopsie"),
          content: new Text(error),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose(){
    myController.dispose();
    super.dispose();
  }

  void _submit() async {

    bool _connected = false;

    try {
      final result = await InternetAddress.lookup('http://10.0.2.2:8080');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _connected = true;
      }else{
        throw Exception ("Server not found");
      }
    } catch (e) {
      _connected = false;
      errorMessage = "Server not found";
      setState(() {
        _saving = false;
      });
    }

    if(myController.text == '' && !_connected){
      errorMessage = "Input field is empty";
      setState(() {
        _saving = false;
      });
      _showDialog(errorMessage);
    }
    else {
      setState(() {
        _saving = true;
      });

      //Simulate a service call
      print('submitting to backend...');

      List<String> input = inputList(myController.text);
      print(input[0]);
      List<User> userList = new List<User>();
      List<StreamData> streamList = new List<StreamData>();
      List<ChannelData> channelList = new List<ChannelData>();

      for (String i in input) {
        print(i);
        try {
          Searches search = new Searches(i);
          final channelResponse = await search.searchChannel();
          final userResponse = await search.searchUser();
          final streamResponse = await search.searchStream();
          print(channelResponse.statusCode);
          //if stream is off or on
          if (userResponse.statusCode == 200 &&
              (streamResponse.statusCode == 200 ||
                  streamResponse.statusCode == 500) &&
              channelResponse.statusCode == 200) {
            print(channelResponse.statusCode);

            // If the call to the server was successful, parse the JSON
            User user = User.fromJson(json.decode(userResponse.body));
            ChannelData channelData = ChannelData.fromJson(
                json.decode(channelResponse.body));
            StreamData streamData;
            String name = streamResponse.request.url.path.replaceAll(
                "/twitch/stream/", "")
                .toString();
            if (streamResponse.statusCode == 200) {
              streamData =
                  StreamData.fromJson(json.decode(streamResponse.body));
              streamData.setName(name);
            }
            else {
              streamData = new StreamData(creationTime: "OFFLINE");
              streamData.setName(name);
            }

            //if there is a user
            if (user.id != null) {
              userList.add(user);
              streamList.add(streamData);
              channelList.add(channelData);
            } else {
              errorMessage = "User(s) not found";
            }
          } else {
            setState(() {
              _saving = false;
            });
            // If that call was not successful, throw an error.
            throw Exception('Backend error');
          }
        } catch (e) {
          print(e);
          setState(() {
            _saving = false;
          });
          //show error
          _showDialog(e.toString());
        }
      }
      //if there is a user
      if (userList.length > 0 && userList != null) {
        setState(() {
          _saving = false;
        });

        Navigator.push(context, new MaterialPageRoute(
            builder: (context) =>
            new SecondScreen(
              user: userList, stream: streamList, channel: channelList,)));
      } else {
        setState(() {
          _saving = false;
        });
        _showDialog(errorMessage);
      }
    }
  }


  static const Map<String, String> variables = const {
    //TODO find a way to put this into text
    'title': 'Analytic',
    'contactInformation': 'T Analytic\nContact: TAnalytic@gmail.com',
    'hintText': 'faker, ninja, etc.',
    'search': 'Search'
  };

    Widget _buildWidget() {
      Widget infoBox = Container(
          child:Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text.rich(
                            TextSpan(// default text style
                              children: <TextSpan>[
                                TextSpan(text: variables['contactInformation'], style: TextStyle(fontStyle: FontStyle.normal, fontSize: 12.0, color: Color(0xFF8a3e74))),

                              ],
                            ),
                            textAlign: TextAlign.center
                        ),
                        //your elements here
                      ],
                    )
                )
                //children Widgets
              ]
          )
      );
      Widget inputAndSearch = Container(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Container(
                        padding: const EdgeInsets.only(bottom:  8.0),
                        child: TextField(
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: Theme.of(context).primaryColor)
                              ),
                              hintStyle: new TextStyle(color: Theme.of(context).hintColor),
                              hintText: variables['hintText']
                          ),
                          controller: myController,
                        )
                    ),
                    Container(
                        padding: const EdgeInsets.only(bottom:  8.0),
                        child: RaisedButton(
                          child: new Text(variables['search'], style: new TextStyle(color: Colors.white)),
                          color: Color(0xFF5b0f48),
                          onPressed: _submit,
                        )
                    )
                  ],
                )
            )
          ],
        ),

      );

      return new Stack(
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('purple1.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          inputAndSearch,
          infoBox,
        ],
      );
    }

    @override
    Widget build(BuildContext context){
    return new Scaffold(
          appBar: AppBar(
            title: Text('Analytic'),
          ),
//        appBar: AppBar(
//          title: Text('Top Lakes'),
//        ),

          body: ModalProgressHUD(child: _buildWidget(), inAsyncCall: _saving)
      );
    }

  }
