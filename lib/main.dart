import 'package:clique/mainMenu.dart';
import 'package:clique/registerScreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'APIWrapper.dart';
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();
Group currentGroup;
String url = 'http://40.114.122.110:8080/';
bool authenticated = false;

void main() async {
  String apiToken = await storage.read(key: 'APIToken');

  // if the token doesnt exist send them to the register/login screen
  if (apiToken == null) {
    // send user to register/login screen
    authenticated = false;
  } else {
    authenticated = true;
//    dynamic headers = {"Authorization": "Bearer " + apiToken};
//
//    final response = await http.post(url, headers: headers);


//    if (response.statusCode == 200) {
//      // send user to main menu
//    } else {
//      // send user to register/login screen
//    }
  }

  runApp(Clique());
}

class Clique extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
//      home: CliqueRegisterScreen(),
      home: (authenticated) ? CliqueMainMenu(startingIndex: 0) : CliqueRegisterScreen(),
    );

  }
}

//class CliqueHomePage extends StatefulWidget {
//  CliqueHomePage({Key key, this.title}) : super(key: key);
//  final String title;
//
//  @override
//  State<StatefulWidget> createState() {
//     return _CliqueHomePageState();
//  }
//}
//
//class _CliqueHomePageState extends State<CliqueHomePage> {
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text("This is a test app")
//          ]
//    )));
//  }
//@}