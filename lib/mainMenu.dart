import 'package:clique/chatWindow.dart';
import 'package:clique/groupView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'APIWrapper.dart';
import 'chatWindow.dart';
import 'main.dart';

class CliqueMainMenu extends StatefulWidget {
  final int startingIndex;

  const CliqueMainMenu({Key key, this.startingIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CliqueMainMenuState();
  }
}

class _CliqueMainMenuState extends State<CliqueMainMenu> with SingleTickerProviderStateMixin {
  Future<List<Group>> groups;
  Position currentPosition;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    _controller.animateTo(widget.startingIndex);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshGroupList() async {
    setState(() {
      getGroups(currentPosition.latitude, currentPosition.longitude);
    });
  }

  bool groupsAreBeingGot = false;
  List<Group> currentGroups;

  Widget buildMap() {
    if (currentGroups == null && !groupsAreBeingGot) {
      groupsAreBeingGot = true;
      getGroups(currentPosition.latitude, currentPosition.longitude).then((groups) {
        setState(() {
          groupsAreBeingGot = false;
          if (groups == null) {
            currentGroups = [];
          }
          else {
            currentGroups = groups;
          }
        });
      });
      return Column(
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
    } else {
      CameraPosition camera =
          new CameraPosition(target: LatLng(currentPosition.latitude, currentPosition.longitude), zoom:16);

      Set<Marker> markers = new Set();

      for (int i = 0; i < currentGroups.length; i++) {
        markers.add(new Marker(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "This is your current group!"
                            ),
                          ],
                        ),
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _controller.animateTo(2);
                          },
                          child: Text("View Group Details"),
                        )
                      ],
                    ),
                  );
                });
          },
            markerId: MarkerId(i.toString()),
            position: LatLng(currentGroups[i].location.latitude, currentGroups[i].location.longitude),
          alpha: .5,
        ));
      }

      return new Column(children: <Widget>[
        SizedBox(
            width: MediaQuery.of(context).size.width, // or use fixed size like 200
            height: MediaQuery.of(context).size.height - 128,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: camera,
              markers: markers,
            )),
      ]);
    }
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
                  child: Padding(
                    padding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: "It doesn't look like there are any groups in your area! Try starting your own!",
                        fillColor: Colors.black,
                      ),
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: RefreshIndicator(
                          child: ListTile(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[Text("Group Name: "), Text(snapshot.data[index].name)],
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
                                                  child: Text("Close", style: TextStyle(color: Colors.white)),
                                                  color: Colors.lightBlueAccent,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                RaisedButton(
                                                  child: Text("Join Group", style: TextStyle(color: Colors.white)),
                                                  color: Colors.lightBlueAccent,
                                                  onPressed: () {
                                                    requestJoin(snapshot.data[index]);
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              title: Text(snapshot.data[index].name)),
                          onRefresh: _refreshGroupList,
                        ),
                      );
                    });
              }
            }),
        RaisedButton(
          child: Text("Add new group!", style: TextStyle(color: Colors.white)),
          color: Colors.lightBlueAccent,
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
                            child: Text("Create", style: TextStyle(color: Colors.white)),
                            color: Colors.lightBlueAccent,
                            onPressed: () {
//                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => new CliqueMainMenu()), (_) => false);
                              _formKey.currentState.validate();
                              Group newGroup = new Group(
                                id: 0,
                                members: [],
                                wannabeMembers: [],
                                location:
                                Location(latitude: currentPosition.latitude, longitude: currentPosition.longitude),
                                messages: [],
                                memberTurnover: 0,
                                name: newGroupName,
                                description: newGroupDescription,
                              );
                              attemptCreateGroup(newGroup).then((_){
                                setState(() {
                                  currentGroups = null;
                                  current = newGroup;
                                });
                              });
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
          title: Text("Clique", style: TextStyle(color: Colors.white)),
        ),
        body: Center(child: (CircularProgressIndicator())),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Clique", style: TextStyle(color: Colors.white)),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            current == null ? groupView(): buildMap(),
            ChatWindow(usersCurrentGroup: current,),
            GroupView()
          ],
          controller: _controller,
        ),
        bottomNavigationBar: Material(
            color: Colors.lightBlueAccent,
            child: TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.home, color: Colors.white)),
                Tab(icon: Icon(Icons.chat_bubble, color: Colors.white)),
                Tab(icon: Icon(Icons.list, color: Colors.white))
              ],
              controller: _controller,
            )),
      );
    }
  }
}
