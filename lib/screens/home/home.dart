import 'package:brew_crew/screens/home/brewList.dart';
import 'package:brew_crew/screens/home/settingsForm.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/modals/brew.dart';

final AuthService _auth = AuthService();
final FirebaseAuth _user = FirebaseAuth.instance;
var currentuser = _user.currentUser;
DatabaseService databaseService = new DatabaseService(uid: currentuser.uid);
// Widget initial = DatabaseService(uid: currentuser.uid).getInitial();
// Widget email = DatabaseService(uid: currentuser.uid).getEmail();
// Widget name = DatabaseService(uid: currentuser.uid).getName();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    //bottom pop-up
    void _showSettingaPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          centerTitle: true,
          title: Text("Brew Crew"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.pink[400],
                child: databaseService.getInitial(),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          elevation: 0.0,
          child: ListView(children: [
            Center(
              child: UserAccountsDrawerHeader(
                accountEmail: databaseService.getEmail(),
                accountName: databaseService.getName(),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(child: Icon(Icons.person)),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                Navigator.pop(context);
                _showSettingaPanel();
              },
              child: ListTile(
                leading: Icon(Icons.update),
                title: Text('Brew update'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("You Must Be Signed In To Use!")));
              },
              child: ListTile(
                  leading: Icon(Icons.settings), title: Text('Settings')),
            ),
            InkWell(
              onTap: () async {
                await _auth.signOut();
              },
              child: ListTile(
                  leading: Icon(Icons.exit_to_app), title: Text('Logout')),
            ),
          ]),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            )),
            child: BrewList()),
      ),
    );
  }
}
