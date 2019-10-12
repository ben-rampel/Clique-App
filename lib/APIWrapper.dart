import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'main.dart';

String url = 'http://40.114.122.110:8080/';

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

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class Message {
  final User author;
  final String content;
  final DateTime date;

  Message({this.author, this.content, this.date});
}

class Group {
  final int id;
  final String name;
  final String description;
  final List<User> members;
  final List<User> wannabeMembers;
  final int memberTurnover;
  final Location location;
  final List<Message> messages;

  Group({
    this.id,
    this.name,
    this.description,
    this.members,
    this.wannabeMembers,
    this.memberTurnover,
    this.location,
    this.messages});

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
    'location': this.location.toJson(),
    'messages': this.messages,
  };
}

// Given a User user, attempts to make a POST request to url, where the body is user.toJson()
// Returns a list of strings with two indices
// If attempt was successful, returns the api token in the first index and null in the second
// If attempt was unsuccessful, returns null in the first index and the request's error in the second
Future<List<String>> attemptAddUser(User user) async {
  final headers = {"Content-Type": "application/json"};
  final response = await http.post(url + "registerUser", body: json.encode(user.toJson()), headers: headers);
  int statusCode = response.statusCode;
  print(statusCode);
  print(response.body);

  return (statusCode == 200) ? [json.decode(response.body)['token'], null] : [null, json.decode(response.body)['error']];
}

// Attempts to make a GET request to url/username
// Returns a new user from the json received if successful, returns the request's error if unsuccessful
Future<dynamic> attemptGetUser(String username) async {
  final response = await http.post(url + 'getUser/' + username);
  int statusCode = response.statusCode;

  return (statusCode == 200) ? User.fromJson(json.decode(response.body)) : json.decode(response.body)['error'];
}

// Takes in a latitude and longitude and attempts to make a POST request to url
// Sends the API token as the header and the latitude and longtiude as the body
// Returns a list of groups retrieved if successful, returns the request's error if unsuccessful
Future<List<Group>> getGroups(double latitude, double longitude) async {
//  return [Group(
//    id: 0,
//    name: "name",
//    description: "test",
//    location: Location(latitude: 0, longitude: 0),
//    memberTurnover: 9,
//    members: [],
//    wannabeMembers: []
//  )];
  String apiToken = await storage.read(key: "APIToken");
  dynamic headers = {"Authorization": "Bearer " + apiToken};

  Map<String, dynamic> body = {
    'latitude': latitude,
    'longitude': longitude,
  };

  final response = await http.get(url + "getGroups/?latitude=" + body["latitude"].toString() + "&longitude=" + body["longitude"].toString(), headers: headers);
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
  String apiToken = await storage.read(key: "APIToken");
  dynamic headers = {"Authorization": "Bearer " + apiToken, "Content-Type": "application/json"};

  final response = await http.post(url + "createGroup", headers: headers, body: json.encode(group.toJson()));
  int statusCode = response.statusCode;

  return (statusCode == 200) ? null : json.decode(response.body)['error'];
}