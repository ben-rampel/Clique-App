import 'dart:async';
import 'dart:convert';

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
  final List<User> members;
  final List<User> wannabeMembers;
  final int memberTurnover;
  final Location location;
  final List<Message> messages;

  Group({this.id, this.members, this.wannabeMembers, this.memberTurnover, this.location, this.messages});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      members: json['members'],
      wannabeMembers: json['wannabeMembers'],
      memberTurnover: json['memberTurnover'],
      location: json['location'],
      messages: json['messages'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'members': this.members,
    'wannabeMembers': this.wannabeMembers,
    'memberTurnover': this.memberTurnover,
    'location': this.location,
    'messages': this.messages,
  };
}

// Given a User user, attempts to make a POST request to url, where the body user.toJson()
// Returns a list of strings with two indices
// If attempt was successful, returns the api token in the first index and null in the second
// If attempt was unsuccessful, returns null in the first index and the request's error in the second
Future<List<String>> attemptAddUser(User user) async {
  final response = await http.post(url, body: user.toJson());
  int statusCode = response.statusCode;

  return (statusCode == 200) ? [json.decode(response.body)['APIToken'], null] : [null, json.decode(response.body)['error']];
}

// Attempts to make a GET request to url
// Returns a new user from the json received if successful, returns the request's error if unsuccessful
Future<dynamic> attemptGetUser() async {
  final response = await http.get(url);
  int statusCode = response.statusCode;

  return (statusCode == 200) ? User.fromJson(json.decode(response.body)) : json.decode(response.body)['error'];
}

// Takes in a latitude and longitude and attempts to make a POST request to url
// Sends the API token as the header and the latitude and longtiude as the body
// Returns a list of groups retrieved if successful, returns the request's error if unsuccessful
Future<List<Group>> getGroups(double latitude, double longitude) async {
  String apiToken = await storage.read(key: "APIToken");
  dynamic headers = {"Authorization": "Bearer " + apiToken};

  Map<String, dynamic> body() => {
    'latitude': latitude,
    'longitude': longitude,
  };

  final response = await http.post(url, headers: headers, body: body());
  int statusCode = response.statusCode;

  if (statusCode == 200) {
    List<dynamic> decoded = json.decode(response.body)['groups'];
    List<Group> groups;

    for (int i = 0; i < decoded.length; i++) {
      groups[i] = Group.fromJson(decoded[i]);
    }

    return groups;
  } else {
    return json.decode(response.body)['error'];
  }
}

// Takes in a group and attempts to make a POST request to url, with the body being group.toJson()
// Returns null if successful, returns the request's error if unsuccessful
Future<String> attemptCreateGroup(Group group) async {
  final response = await http.post(url, body: group.toJson());
  int statusCode = response.statusCode;

  return (statusCode == 200) ? null : json.decode(response.body)['error'];
}