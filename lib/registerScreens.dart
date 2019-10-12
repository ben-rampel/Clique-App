import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frideos_core/frideos_core.dart';

import 'APIWrapper.dart';
import 'main.dart';
import 'mainMenu.dart';

class CliqueRegisterScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CliqueRegisterScreenState();
  }
}

class _CliqueRegisterScreenState extends State<CliqueRegisterScreen> {
  String username;
  String password;
  String email;
  String phone;
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Clique"),
        ),
        body: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(hintText: "Username"),
                    textAlign: TextAlign.center,
                    validator: (String input) {
                      username = input;
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Password"),
                    obscureText: true,
                    textAlign: TextAlign.center,
                    validator: (String input) {
                      password = input;
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Phone Number"),
                    obscureText: true,
                    textAlign: TextAlign.center,
                    validator: (String input) {
                      phone = input;
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Email"),
                    textAlign: TextAlign.center,
                    validator: (String input) {
                      email = input;
                      return null;
                    },
                  ),
                  RaisedButton(
                      onPressed: () {
                        _formKey.currentState.validate();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserInformationScreen(
                                      username: username,
                                      password: password,
                                      email: email,
                                    )));
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Text("Next"), Icon(Icons.arrow_right)],
                        ),
                      ))
                ],
              ),
            )
          ],
        ));
  }
}

class UserInformationScreen extends StatefulWidget {
  final String username;
  final String password;
  final String email;

  const UserInformationScreen({Key key, this.username, this.password, this.email}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserInformationScreenState();
  }
}


class _UserInformationScreenState extends State<UserInformationScreen> {
  List<String> interests;
  String bio;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Clique"),
        ),
        body: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Interests (comma seperated)",
                    ),
                    validator: (String newValue) {
                      interests = newValue.split(",");
                      return null;
                    },
                    textAlign: TextAlign.center,
                  ),
                  TextFormField(
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Bio (let people know who you are!)",
                    ),
                    validator: (String newValue) {
                      interests = newValue.split(",");
                      return null;
                    },
                    textAlign: TextAlign.center,
                  ),
                  RaisedButton(
                    child: Text("Finish!"),
                    onPressed: () async {
                      _formKey.currentState.validate();
                      User currentUserData = User(
                        username: widget.username,
                        password: widget.password,
                        firstName: "",
                        lastName: "",
                        bio: bio,
                        interests: interests,
                      );
                      List<String> responseData = await attemptAddUser(currentUserData);
                      if (responseData[0] == null) {
                        print(responseData[1]);
                      }
                      else {
                        storage.write(key: "APIToken", value: responseData[0]);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CliqueMainMenu()));
                      }
                    },
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}


