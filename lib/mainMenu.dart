import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'APIWrapper.dart';

class CliqueMainMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CliqueMainMenuState();
  }
}

class _CliqueMainMenuState extends State<CliqueMainMenu> {
  Future<List<Group>> groups;
  Position currentPosition;

  @override
  void initState() {
    super.initState();
  }

  String newGroupName;
  String newGroupDescription;

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((result) {
        currentPosition = result;
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
          body: Column(
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
                            return Card(child: ListTile(onTap: () {}, title: Text(snapshot.data[index].name)));
                          });
                    }
                  }),



              RaisedButton(
                child: Text("Add new group!"),
                onPressed: () {
                  showDialog(context: context, builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Create A Group"),
                      content: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Group Name"
                              ),
                              textAlign: TextAlign.center,
                              validator: (String newValue) {
                                newGroupName = newValue;
                                return null;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Give a brief description of your group!"
                              ),
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
                              setState(() {

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
          ));
    }
  }
}