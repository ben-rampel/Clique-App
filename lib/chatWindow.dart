import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clique/stompLibrary.dart';
import "package:stomp/stomp.dart";
import "package:stomp/impl/plugin.dart";
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'APIWrapper.dart';

class ChatWindow extends StatefulWidget {
  final Group usersCurrentGroup;

  const ChatWindow({Key key, this.usersCurrentGroup}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatWindowState();
  }
}

class _ChatWindowState extends State<ChatWindow> {
  List<String> messages;
  List<String> tempMessages = [];
  String message;
  StompClient client;

  @override
  void initState() {
    connect("ws://152.23.250.34:8080/socket").then((StompClient newClient) {
      print("I got here");
      newClient.subscribeString("messages", "/chat/" + widget.usersCurrentGroup.id.toString(),
          (Map<String, String> headers, String message) {
          if(messages == null) {
            tempMessages.add(message);
          }
          else {
            messages.add(message);
          }
          });
      client = newClient;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    if (messages == null) {
//      getMessages(widget.usersCurrentGroup.id.toString()).then((newMessages){
//        setState(() {
//          messages = newMessages;
//          if (tempMessages != null) {
//            for (int i = 0; i<tempMessages.length; i++) {
//              messages.add(tempMessages[i]);
//            }
//          }
//        });
//      });
//
//      return Column(
//        children: <Widget>[
//          Center(child: CircularProgressIndicator())
//        ],
//      );
//    }


    return Column(
      children: <Widget>[
        ListView.builder(
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(message[index]);
          },
        ),
        Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (String newInput) {
                  message = newInput;
                  return null;
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
