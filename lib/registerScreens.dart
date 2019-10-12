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

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Clique"),
        ),
        body: Column(
          children: <Widget>[
            Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Register",
                      ),
                      style: new TextStyle(
                        fontSize: 30.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: new EdgeInsets.only(left: 5.0, right: 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Username",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(16.0),
                            borderSide: new BorderSide()),
                        contentPadding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      ),
                      textAlign: TextAlign.left,
                      autocorrect: false,
                      validator: (String input) {
                        username = input;
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: new EdgeInsets.only(left: 5.0, right: 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(16.0),
                            borderSide: new BorderSide()),
                        contentPadding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      ),
                      obscureText: true,
                      textAlign: TextAlign.left,
                      autocorrect: false,
                      validator: (String input) {
                        password = input;
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: new EdgeInsets.only(left: 5.0, right: 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(16.0),
                            borderSide: new BorderSide()),
                        contentPadding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      ),
                      textAlign: TextAlign.left,
                      autocorrect: false,
                      validator: (String input) {
                        phone = input;
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: new EdgeInsets.only(left: 5.0, right: 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(16.0),
                            borderSide: new BorderSide()),
                        contentPadding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      ),
                      textAlign: TextAlign.left,
                      autocorrect: false,
                      validator: (String input) {
                        email = input;
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(
                    width: 90.0,
                    child: RaisedButton(
                        onPressed: () {
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
                  ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Clique"),
        ),
        body: Column(
          children: <Widget>[
            Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Register",
                      ),
                      style: new TextStyle(
                        fontSize: 30.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: new EdgeInsets.only(left: 5.0, right: 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Interests (comma separated)",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(16.0),
                            borderSide: new BorderSide()),
                        contentPadding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      ),
                      validator: (String newValue) {
                        interests = newValue.split(",");
                        return null;
                      },
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: new EdgeInsets.only(left: 5.0, right: 5.0),
                    child: TextFormField(
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "Bio (let people know who you are!)",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(16.0),
                            borderSide: new BorderSide()),
                        contentPadding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      ),
                      validator: (String newValue) {
                        interests = newValue.split(",");
                        return null;
                      },
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(
                    width: 80.0,
                    child: RaisedButton(
                      child: Text("Finish!"),
                      onPressed: () async {
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
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
}


