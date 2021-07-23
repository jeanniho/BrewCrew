import 'package:brew_crew/screens/home/home.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constVariables.dart';
import 'package:brew_crew/shared/loading.dart';

class SignUp extends StatefulWidget {
  final toggleView;
  SignUp({this.toggleView});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  String errorMessage = "";
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text("Sign up to Brew Crew"),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text("Login"))
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
                          keyboardType: TextInputType.text,
                          controller: _nameController,
                          decoration:
                              textInputDecoration.copyWith(labelText: "Name"),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Enter a valid name';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _surnameController,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Surname"),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Enter a valid surname';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Phone no"),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Enter a valid phone number';
                            } else {
                              return null;
                            }
                          }),
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
                              return 'Enter a valid email address';
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
                          setState(() {
                            loading = true;
                          });
                          if (_formkey.currentState.validate()) {
                            dynamic user =
                                await _auth.signUpWithEmailAndPassword(
                                    _nameController.text,
                                    _surnameController.text,
                                    _phoneController.text,
                                    _emailController.text,
                                    _passwordController.text);
                            if (user == null) {
                              setState(() {
                                errorMessage = "Registration was unsuccessful";
                                loading = false;
                              });
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home()
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
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
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
 