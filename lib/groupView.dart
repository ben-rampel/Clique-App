import 'package:flutter/material.dart';

import 'APIWrapper.dart';
import 'main.dart';

class GroupView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GroupViewState();
  }
}

class _GroupViewState extends State<GroupView> {
  Group currentGroup;

  bool beingQueryered = false;

  @override
  Widget build(BuildContext context) {
    if (currentGroup == null) {
      if (!beingQueryered) {
        beingQueryered = true;
        getCurrentGroup().then((result) {
          beingQueryered = false;
          setState(() {
            currentGroup = result;
          });
        });
      }
      return Column(
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Card(
              color: Colors.white,
              child: ListTile(
                title: Center(child: Text("Group: " + currentGroup.name)),
              )),
          ListView.builder(
              shrinkWrap: true,
              itemCount: currentGroup.members.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(User.fromJson(currentGroup.members[index]).username),
                  ),
                );
              }),
          Container(
            height: MediaQuery.of(context).size.height - 256,
          child: Align(
            alignment: FractionalOffset.bottomLeft,
            child: RaisedButton(
              onPressed: () {
                leaveGroup(currentGroup.id.toString()).then((_){
                  setState(() {
                    current = null;
                  });
                }
                );
              },
              child: Text("Leave Group"),
            ),
          ))
        ],
      );
    }
  }
}
