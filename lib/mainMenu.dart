import 'package:clique/chatWindow.dart';
import 'package:clique/main.dart';
import 'package:clique/registerScreens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'APIWrapper.dart';

class CliqueMainMenu extends StatefulWidget {
  final int startingIndex;

  const CliqueMainMenu({Key key, this.startingIndex}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CliqueMainMenuState();
  }
}

class _CliqueMainMenuState extends State<CliqueMainMenu> with SingleTickerProviderStateMixin{
  Future<List<Group>> groups;
  Position currentPosition;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _controller.animateTo(widget.startingIndex);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Widget groupView() {
    return Column(
      children: <Widget>[
        FutureBuilder(
            future: getGroups(currentPosition.latitude, currentPosition.longitude),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done && snapshot.data == null) {
                return Center(
                    child: Text("It doesn't look like there's any groups in your area! Try starting one!"));
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(child: ListTile(
                          onTap: () {
                            showDialog(context: context, builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Group Name: "),
                                        Text(snapshot.data[index].name)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Group Description: "),
                                        Text(snapshot.data[index].description)
                                      ],
                                    ),
//                                          Row(
//                                            mainAxisAlignment: MainAxisAlignment.center,
//                                            children: <Widget>[
//                                              Text("Main Interests: "),
//                                              Text(snapshot.data[index].mainInterests)
//                                            ],
//                                          )
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        RaisedButton(
                                          child: Text("Close"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        RaisedButton(
                                          child: Text("Join Group"),
                                          onPressed: () {
                                            //TODO
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                          title: Text(snapshot.data[index].name
                          )
                      )
                      );
                    });
              }
            }),
        RaisedButton(
          child: Text("Add new group!"),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Create A Group"),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(hintText: "Group Name"),
                            textAlign: TextAlign.center,
                            validator: (String newValue) {
                              newGroupName = newValue;
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: "Give a brief description of your group!"),
                            textAlign: TextAlign.center,
                            validator: (String newValue) {
                              newGroupDescription = newValue;
                              return null;
                            },
                          ),
                          RaisedButton(
                            child: Text("Create"),
                            onPressed: () {
//                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => new CliqueMainMenu()), (_) => false);
                              _formKey.currentState.validate();
                              Group newGroup = new Group(
                                id: 0,
                                members: [],
                                wannabeMembers: [],
                                location: Location(
                                    latitude: currentPosition.latitude, longitude: currentPosition.longitude),
                                messages: [],
                                memberTurnover: 0,
                                name: newGroupName,
                                description: newGroupDescription,
                              );
                              attemptCreateGroup(newGroup);
                              setState(() {});
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        )
      ],
    );
  }

  String newGroupName;
  String newGroupDescription;
  TabController _controller;

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((result) {
        setState(() {
          currentPosition = result;
        });
      });
      return Scaffold(
        appBar: AppBar(
          title: Text("Clique"),
        ),
        body: Center(child: (CircularProgressIndicator())),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Clique"),
        ),
        body: TabBarView(
            children: <Widget>[groupView(), ChatWindow(usersCurrentGroup: currentGroup,)],
            controller: _controller,
        ),
        bottomNavigationBar: Material(
          color: Colors.lightBlueAccent,
          child: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.chat_bubble))
            ],
            controller: _controller,
          )
        ),
      );
    }
  }
}
