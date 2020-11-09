import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_manager/app/app_home_screen.dart';
import 'package:grocery_manager/app_theme.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Builder(
        builder: (BuildContext context) => SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bermuda-welcome.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
              key: _form,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextFormField(
                          controller: usernameController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Username is mandatory';
                            }
                            return null;
                          },
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0x50FEFEFE),
                            suffixIcon: Icon(
                              Icons.person,
                              color: Colors.green,
                            ),
                            border: const OutlineInputBorder(),
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.green),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Email is mandatory';
                            }
                            return null;
                          },
                          obscureText: true,
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0x50FFFFFF),
                            suffixIcon: Icon(
                              Icons.lock,
                              color: Colors.green,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Colors.green,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Row(
                          children: [
                            Expanded(
                              child: RaisedButton(
                                color: Colors.green,
                                child: Container(
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      "Log in",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  // verify
                                  if (_form.currentState.validate()) {

                                    try {
                                      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                          email: usernameController.text.trim(),
                                          password: passwordController.text.trim(),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AppHomeScreen(),
                                        ),
                                      );
                                    } catch(e) {
                                      if (e.code == 'user-not-found') {
                                        snackBar(context, 'No user found for that email.');
                                      } else if (e.code == 'wrong-password') {
                                        snackBar(context, 'Wrong password provided for that user.');
                                      } else if (e.code == 'invalid-email') {
                                        snackBar(context, 'Invalid email');
                                      } else {
                                        snackBar(context, 'Something went wrong');
                                      }
                                    }
                                  } else {
                                    snackBar(
                                      context,
                                      'Fill all mandatory fields',
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void snackBar(context, text) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green[300],
      content: Expanded(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Icon(Icons.warning),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Text(text),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
