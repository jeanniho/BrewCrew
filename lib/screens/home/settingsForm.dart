import 'package:brew_crew/modals/brew.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constVariables.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ["0", "1", "2", "3", "4", "5", "6"];
  String _name, _sugar, _drink;
  int _strength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return SingleChildScrollView(
      child: StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;
              return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Update your brew settings",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0,),
                    TextFormField(
                      initialValue: userData.name,
                      decoration:
                          textInputDecoration.copyWith(labelText: "Name"),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please enter a name";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          _name = val;
                        });
                      },
                    ),
                    SizedBox(height: 8.0,),
                    TextFormField(
                      initialValue: userData.drink,
                      decoration:
                          textInputDecoration.copyWith(labelText: "Drink"),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please enter your beverage or type none";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          _drink = val;
                        });
                      },
                    ),
                    SizedBox(height: 8.0,),
                    DropdownButtonFormField(
                        value: _sugar ?? userData.sugar,
                        decoration: textInputDecoration,
                        items: sugars.map((sugar) {
                          return DropdownMenuItem(
                              value: sugar,
                              child: Text(
                                "$sugar sugar(s)",
                              ));
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _sugar = val;
                          });
                        }),
                    SizedBox(height: 8.0,),
                    Slider(
                      min: 100,
                      max: 900,
                      divisions: 8,
                      value: (_strength ?? userData.strength).toDouble(),
                      onChanged: (val) {
                        setState(() {
                          _strength = val.round();
                        });
                      },
                      activeColor: Colors.brown[_strength ?? userData.strength],
                      inactiveColor:
                          Colors.brown[_strength ?? userData.strength],
                    ),
                    SizedBox(height: 8.0,),
                    FlatButton(
                        color: Colors.pink[400],
                        onPressed: () async {
                          Navigator.pop(context);
                          if (_formKey.currentState.validate()) {
                            await DatabaseService(uid: user.uid).updateUserData(
                              _name ?? userData.name,
                              _sugar ?? userData.sugar,
                              _strength ?? userData.strength,
                              _drink ?? userData.drink,
                            );
                            
                          }
                        },
                        child: Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              );
            } else {
              return Loading();
            }
          }),
    );
  }
}
