import 'package:clique/mainMenu.dart';
import 'package:clique/registerScreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(Clique());

final storage = FlutterSecureStorage();


class Clique extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CliqueHomePage(),
    );
  }
}

class CliqueHomePage extends StatefulWidget {
  CliqueHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
     return _CliqueHomePageState();
  }
}

class _CliqueHomePageState extends State<CliqueHomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is a test app")
          ]
    )));
  }
}