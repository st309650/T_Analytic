import 'user.dart';
import 'stream_data.dart';
import 'channel_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//purpose is to create each search per person
class Searches{
   String name;

  Searches(String name){
    this.name = name;
  }

  Future<http.Response> searchUser() async{

    String userRequest = "http://10.0.2.2:8080/twitch/user/" + name;
    return http.get(userRequest);
   }
   Future<http.Response> searchStream() async{

     String streamRequest = "http://10.0.2.2:8080/twitch/stream/" + name;
      return http.get(streamRequest);
   }
   Future<http.Response> searchChannel() async{

     String channelRequest = "http://10.0.2.2:8080/twitch/channel/" + name;
     return http.get(channelRequest);
   }
}