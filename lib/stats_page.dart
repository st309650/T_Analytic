import 'package:flutter/material.dart';
import 'user.dart';
import 'channel_data.dart';
import 'stream_data.dart';

class StatisticPage extends StatelessWidget {
  final User user;
  final StreamData stream;
  final ChannelData channelData;

  StatisticPage({Key key, @required this.user, @required this.stream, @required this.channelData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stats"),
      ),
      body: Center(
          child: CustomCard(user: user, streamData: stream, channelData: channelData,)
      ),
    );
  }
}

class CustomCard extends StatelessWidget {

  final User user;
  final StreamData streamData;
  final ChannelData channelData;
  CustomCard({Key key, @required this.user, @required this.streamData, @required this.channelData}) : super(key: key);

  //name
  Text _name(String name, BuildContext context) {
    return new Text(
      name,
      style: new TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).secondaryHeaderColor),
    );
  }
  bool _offline(){
    if(streamData.creationTime == "OFFLINE")
      return true;
    else
      return false;
  }

  Container titleSection(bool _offline) {
    return new Container(
      // padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          // Expanded(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status: ',
                style: TextStyle(
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          //),
          Container(
            //  padding: EdgeInsets.all(50.0),
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

  Padding _customText(String description, String actual){
      return new Padding(padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
        child: Text(description + ": " + (_offline() || actual == null ? "NA": actual),
                    style: TextStyle(color: Colors.black),)
                    );
  }

  Padding _otherText(String description, String actual){
    return new Padding(padding: EdgeInsets.symmetric(horizontal:  15.0, vertical:  1.0),
      child: Text( description + ": " + (actual == null? "NA" : actual),
          style: TextStyle(color: Colors.black)));
  }
  @override
  Widget build(BuildContext context) {

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Card(
        margin: EdgeInsets.all(10.0),
        elevation: 5.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
              ListTile(
                title: _name("Stream", context),
              ),
            _otherText('Name', streamData.name),
            _otherText('Creation Date', streamData.creationTime),
            _customText('Game', streamData.game),
            _customText('FPS', streamData.fps),
            _customText('Viewers', streamData.viewers),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            )
            //_divider(),
          ],
        ),
        ),
        Card(
          margin: EdgeInsets.all(10.0),
          elevation: 5.0,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: _name("Channel", context),
              ),
              _otherText("Name", channelData.name),
              _otherText("Display Name", channelData.displayName),
              _otherText("Creation Time", channelData.creationTime),
              _otherText("Language", channelData.language),
              _otherText("Status", channelData.status),
              _otherText("Updated Time", channelData.updatedTime),
              _otherText("URL", channelData.url),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              )
            ]
          ),
        ),
      ],
    );
  }
}
