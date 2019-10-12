import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

String url = 'google.com';

class User {
  final String username;
  final String firstName;
  final String lastName;
  final String password;
  final List<String> interests;
  final String bio;

  User({this.username, this.firstName, this.lastName, this.password, this.interests, this.bio});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      password: json['password'],
      interests: json['interests'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': this.username,
    'firstName': this.firstName,
    'lastName': this.lastName,
    'password': this.password,
    'interests': this.interests,
    'bio': this.bio,
  };
}

class Location {
  final double latitude;
  final double longitude;

  Location({this.latitude, this.longitude});
}

class Message {
  final User author;
  final String content;
  final DateTime date;

  Message({this.author, this.content, this.date});
}

class Group {
  final int id;
  final Map<int, User> members;
  final Set<int> pendingMembers;
  final int memberTurnover;
  final Location location;
  final List<Message> messages;

  Group({this.id, this.members, this.pendingMembers, this.memberTurnover, this.location, this.messages});

  // this dont work i think
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      members: json['members'],
      pendingMembers: json['pendingMembers'],
      memberTurnover: json['memberTurnover'],
      location: json['location'],
      messages: json['messages'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'members': this.members,
    'pendingMembers': this.pendingMembers,
    'memberTurnover': this.memberTurnover,
    'location': this.location,
    'messages': this.messages,
  };
}

Future<List<String>> attemptAddUser(user) async {
  // make POST request
  final response = await http.post(url, body: user.toJson());

  // check the status code of the response for the result
  int statusCode = response.statusCode;

  // return a list with two indices
  // if request was successful make the first index the api token and the second null
  // if request was unsuccessful make the first index null and the second index the error
  if (statusCode == 200) {
    return [json.decode(response.body)['APIToken'], null];
  } else {
    return [null, json.decode(response.body)['error']];
  }
}

Future<dynamic> attemptGetUser() async {
  // make GET request
  final response = await http.get(url);

  // check the status code of the response for the result
  int statusCode = response.statusCode;

  // if request was successful return a new user object from the request's data
  // if request was unsuccessful return the error (which will be encoded in the request)
  if (statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
    return json.decode(response.body)['error'];
  }
}

// this function returns all the groups near the given latitude and longitude
// takes in two doubles
Future<List<Group>> getGroups(latitude, longitude) async {
  String apiToken = await storage.read(key: "APIToken");
  dynamic headers = {"Authorization": "Bearer " + apiToken};

  Map<String, dynamic> body() => {
    'latitude': latitude,
    'longitude': longitude,
  };

  // make POST request
  final response = await http.post(url, headers: headers, body: body());

  // check the status code of the response for the result
  int statusCode = response.statusCode;

  // if request was successful return a list of groups
  // if request was unsuccessful return the error (which will be encoded in the request)
  if (statusCode == 200) {
    // i don't think that this will work i not sure tho
    return json.decode(response.body)['groups'];
  } else {
    return json.decode(response.body)['error'];
  }
}

Future<String> attemptCreateGroup(group) async {
  // make POST request
  final response = await http.post(url, body: group.toJson());

  // check the status code of the response for the result
  int statusCode = response.statusCode;

  // return a list with two indices
  // if request was successful return null
  // if request was unsuccessful return the error (which will be encoded in the request)
  if (statusCode == 200) {
    return null;
  } else {
    return json.decode(response.body)['error'];
  }
}

User testUser = new User(
  username: 'brytonsf',
  firstName: 'bryton',
  lastName: 'shoffner',
  password: 'password69',
  interests: ['swag', 'money'],
  bio: 'im a 22 year old man',
);
