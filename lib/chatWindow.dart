import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stomp/stomp.dart';
import "package:stomp/vm.dart" show connect;

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
  Future<List<String>> messages;
  String message;

  @override
  void initState() {
    connect("foo.server.com").then((StompClient client) {
      client.subscribeString("messages", "http://40.114.122.110:8080/chat/" + widget.usersCurrentGroup.id.toString(),
              (Map<String, String> headers, String message) {
            print("Recieve $message");
          });

      client.sendString("/foo", "Hi, Stomp");
    });
    messages = getMessages(widget.usersCurrentGroup.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: messages,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator(),);
            }
            else if (snapshot.data == null && snapshot.connectionState == ConnectionState.done) {
              return Center(child: Text("No messages found! Try sending one!"),);
            }
            else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return Text(snapshot.data[index]);
              },
              );
            }
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
