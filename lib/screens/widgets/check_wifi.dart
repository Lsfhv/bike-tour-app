import 'dart:async';

import 'package:flutter/material.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';




class CheckWifi{

  CheckWifi();

  @override
  void dispose(){
    listener!.cancel();
  }

  StreamSubscription<DataConnectionStatus>? listener;
  var InternetStatus = "Unknown";
  var contentmessage = "Unknown";

  checkConnection(BuildContext context) async{
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status){
        case DataConnectionStatus.connected:
          // InternetStatus = "Connected to the Internet";
          // contentmessage = "Connected to the Internet";
          // _showDialog(InternetStatus,contentmessage,context);
          break;
        case DataConnectionStatus.disconnected:
          InternetStatus = "You are disconnected to the Internet. ";
          contentmessage = "Please check your internet connection";
          _showDialog(InternetStatus,contentmessage,context);
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  void _showDialog(String title, String content ,BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              title: new Text(title),
              content: new Text(content),
              actions: <Widget>[
                new FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child:new Text("Close") )
              ]
          );
        }
    );
  }
}