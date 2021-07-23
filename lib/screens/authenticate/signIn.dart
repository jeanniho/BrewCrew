import 'package:brew_crew/screens/home/home.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constVariables.dart';
import 'package:brew_crew/shared/loading.dart';

class SignIn extends StatefulWidget {
  final toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loading = false;
  String errorMessage = "";
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text("Sign in to Brew Crew"),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text("Register"))
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 50,
              ),
              child: ListView(children: <Widget>[
                Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration:
                              textInputDecoration.copyWith(labelText: "Email"),
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter a valid email address";
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Password"),
                          validator: (val) {
                            if (val.length < 6) {
                              return 'Short password, password must be 6 characters long';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(
                        height: 16.0,
                      ),
                      FlatButton(
                        color: Colors.brown[400],
                        onPressed: () async {
                          if (_formkey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic user =
                                await _auth.signInWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text);
                            if (user == null) {
                              setState(() {
                                errorMessage = "Unable to sign in";
                                loading = false;
                              });
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home())
                                );
                            }
                          }
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Center(
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          );
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
