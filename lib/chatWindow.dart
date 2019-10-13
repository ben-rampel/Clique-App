import 'package:clique/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
  String message;
  static final _formKey1 = GlobalKey<FormState>();
  static final _formKey2 = GlobalKey<FormState>();


  var subscription;
  Future<List<Message>> messages;

@override
  void initState() {
    // TODO: implement initState
    messages = getMessages(getMessages(widget.usersCurrentGroup.id.toString()));
  }
  @override
  Widget build(BuildContext context) {



    if (widget.usersCurrentGroup == null) {
      return Column(children: <Widget>[Center(child: Text("Join a group to see the chat!"))]);
    }



    // TODO: implement build
    return RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          return;
        },
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: messages,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null && snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  } else if ((snapshot.data == null || snapshot.data.isEmpty) &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Column(children: <Widget>[
                      Center(child: Text("No results found!")),
                      Form(
                          key: _formKey1,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                  height: 30,
                                  width: 200,
                                  child: TextFormField(
                                    validator: (String newValue) {
                                      message = newValue;
                                      return null;
                                    },
                                  )),
                              SizedBox(
                                  height: 20,
                                  child: RaisedButton(
                                      onPressed: () {
                                        _formKey1.currentState.validate();
                                        sendMessage(current.id.toString(), message.replaceAll(" ", "+")).then((_) {
                                          setState(() {});
                                        });
                                      },
                                      child: Icon(Icons.arrow_right)))
                            ],
                          ))
                    ]);
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == snapshot.data.length) {
                            return Form(
                                key: _formKey2,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                        height: 30,
                                        width: 200,
                                        child: TextFormField(
                                          validator: (String newValue) {
                                            message = newValue;
                                            return null;
                                          },
                                        )),
                                    SizedBox(
                                        height: 20,
                                        child: RaisedButton(
                                            onPressed: () {
                                              _formKey2.currentState.validate();
                                              sendMessage(current.id.toString(), message.replaceAll(" ", "+"))
                                                  .then((_) {
                                                setState(() {
                                                  messages = getMessages(widget.usersCurrentGroup.id.toString());
                                                });
                                              });
                                            },
                                            child: Icon(Icons.arrow_right)))
                                  ],
                                ));
                          } else {
                            return Text(snapshot.data[index].content);
                          }
                        });
                  }
                }),
          ],
        ));
  }
}
