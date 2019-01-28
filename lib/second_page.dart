import 'package:flutter/material.dart';
import 'user.dart';
import 'stream_data.dart';
import 'stats_page.dart';
import 'channel_data.dart';
import 'dart:math' as math;

class SecondScreen extends StatelessWidget {

  final List<User> user;
  final List<StreamData> stream;
  final List<ChannelData> channel;
  SecondScreen({Key key, @required this.user, @required this.stream, @required this.channel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Streamers"),
      ),
      body: Center(
        child: CustomCard(user: user, stream: stream, channel: channel,)
      ),
    );
  }
}

class CustomCard extends StatelessWidget {

  final List<User> user;
  final List<StreamData> stream;
  final List<ChannelData> channel;

  CustomCard({Key key, @required this.user, @required this.stream,@required this.channel }) : super(key: key);
  //icon
  CircleAvatar _avatar(String name, Color color){
    return new CircleAvatar(
      backgroundColor: color,
      child: new Text(name[0].toUpperCase(),
        style: TextStyle(
          color: Colors.white
      ),),
    );
  }

  //name
  Text _name(String name) {
    return new Text(
      name,
      style: new TextStyle(fontWeight: FontWeight.bold),
    );
  }

  //Description
  Text _description(String description) {
    return new Text(description, textAlign: TextAlign.left,);
  }

  FlatButton _expand(BuildContext context, User user, StreamData stream, ChannelData channel){
    return new FlatButton(
        child: new Text("More", style: TextStyle(color: Theme.of(context).secondaryHeaderColor ),),
        //color: Colors.pinkAccent,
        onPressed: (){
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new StatisticPage(
                  user: user, stream: stream, channelData: channel,))
          );
        }// expand to new thing,
    );
  }

  bool _offline(String creationTime){
    if(creationTime == "OFFLINE")
      return true;
    else
      return false;
  }


  Container titleSection(bool _offline) {
    return new Container(
      child: Row(
        children: [
          // Expanded(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status: ',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          //),
          Container(
            height: 15.0,
            width: 15.0,
            decoration: new BoxDecoration(
              color: _offline ? Colors.red : Colors.green,
              shape: BoxShape.circle,
            ),
          ),
        ],

      ),
    );
  }

    @override
    Widget build(BuildContext context) {

      return ListView.builder(
        itemBuilder: (context, index){
          return Center(
            child: Card(
              margin: EdgeInsets.all(10.0),
              elevation: 5.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: _avatar(user[index].name == null ? "NA" : user[index].name,  Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(.85)),
                    title: _name(user[index].name == null ? "NA" : user[index].name.toUpperCase()),
                    subtitle: titleSection(_offline(stream[index].creationTime)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    alignment: Alignment.centerLeft,
                    child:  _description(user[index].bio ==  null? "NA" : user[index].bio),
                  ),
                  //_divider(),
                  ButtonTheme.bar(
                    // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      children: <Widget>[
                        _expand(context, user[index], stream[index], channel[index])
                      ],
                    ),
                  ),
                ],

              ),

            ),
          );
        },
        itemCount: user.length,);

    }
  }
