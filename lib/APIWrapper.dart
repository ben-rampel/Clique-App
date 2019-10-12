import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'main.dart';

int test = 0;


class User {
  final String username;
  final String firstName;
  final String lastName;
  final String password;
  final List<String> interests;
  final String bio;

  User({this.username, this.firstName, this.lastName, this.password, this.interests, this.bio});
}

class Group {
  final List<double> location;
  final String name;
  final String description;
  final User creator;

  Group({this.location, this.name, this.description, this.creator});
}


Future<List<String>> attemptAddUser(userObject) async {

}

Future<List<Group>> getGroups(double lat, double long) async {
  print("I'm being called!");
  if (test == 1) {
    Group test = Group(location: [1, 2], name:"test", description: "test", creator: null);
    return [test];
  }
  test += 1;
  return null;

}

Future<String> attemptCreateGroup(groupObject) async {

}