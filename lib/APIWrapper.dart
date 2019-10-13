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
  final List<dynamic> interests;
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

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }
}

class Message {
  final User author;
  final String content;
  final String date;

  Message({this.author, this.content, this.date});
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        content: json["content"],
        date: json["date"],
        author: User.fromJson(json["author"])
    );
  }
}

class Group {
  final int id;
  final String name;
  final String description;
  final List<dynamic> members;
  final List<dynamic> wannabeMembers;
  final int memberTurnover;
  final Location location;
  final List<dynamic> messages;

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
      name: json["name"],
      description: json["description"],
      members: json['members'],
      wannabeMembers: json['wannabeMembers'],
      memberTurnover: json['memberTurnover'],
      location: Location.fromJson(json['location']),
      messages: json['groupMessages'],
    );
  }

  Map<String, dynamic> toJson() => {
//    'id': this.id,
//    'members': this.members,
//    'wannabeMembers': this.wannabeMembers,
//    'memberTurnover': this.memberTurnover,
    'name': this.name,
    'description': this.description,
    'location': this.location.toJson(),
//    'messages': this.messages,
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
  String apiToken = await storage.read(key: "APIToken");
  dynamic headers = {"Authorization": "Bearer " + apiToken};

  Map<String, dynamic> body = {
    'latitude': latitude,
    'longitude': longitude,
  };

  final response = await http.get(url + "getGroups/?latitude=" + body["latitude"].toString() + "&longitude=" + body["longitude"].toString(), headers: headers);
  int statusCode = response.statusCode;

  if (statusCode == 200) {
    print(json.decode(response.body));
    List<dynamic> decoded = json.decode(response.body)['groups'];
    List<Group> groups = [];

    for (int i = 0; i < decoded.length; i++) {
      groups.add(Group.fromJson(decoded[i]));
    }
    return groups.length == 0 ? null: groups;
  } else {
    print("I'm getting here");
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

Future<List<Message>> getMessages(groupID) async {
  String apiToken = await storage.read(key: "APIToken");
  dynamic headers = {"Authorization": "Bearer " + apiToken};
  final response = await http.get(url + "chat/" + groupID + "/messages", headers: headers);
  
  dynamic results = json.decode(response.body); 
  List<Message> returnList = []; 
  for (int i = 0; i <results.length; i++) {
    returnList.add(Message.fromJson(results[i])); 
  }
  return returnList;
}


Future<void> sendMessage(String groupID, String message) async {
  String apiToken = await storage.read(key: "APIToken");
  dynamic headers = {"Authorization": "Bearer " + apiToken};
  final response = await http.post(url + "chat/" + groupID + "/sendMessage?message=" + message, headers: headers);
  print(response.statusCode);
}

Future<void> requestJoin(Group groupToJoin) async {
  String apiToken = await storage.read(key: "APIToken");
  dynamic headers = {"Authorization": "Bearer " + apiToken};
  final response = await http.post(url + "groups/" + groupToJoin.id.toString() + "/requests", headers: headers);
  print(response.statusCode);
}


Future<Group> getCurrentGroup() async {
  String apiToken = await storage.read(key: "APIToken");
  dynamic headers = {"Authorization": "Bearer " + apiToken};
  final response = await http.get(url + "me", headers: headers);
  if (json.decode(response.body)["currentGroup"] == null) {
    return null;
  }
  else {
    final currentGroupMeta =  Group.fromJson(json.decode(response.body)["currentGroup"]);
    final newResponse = await http.get(url + "groups/" + currentGroupMeta.id.toString(), headers: headers);
    return Group.fromJson(json.decode(newResponse.body));
  }
}

Future<void> leaveGroup(groupid) async {
  String apiToken = await storage.read(key: "APIToken");
  dynamic headers = {"Authorization": "Bearer " + apiToken};
  final response = await http.delete(url + "groups/" + groupid + "/me", headers: headers);
  print(response.statusCode);
  print(response.body);

}