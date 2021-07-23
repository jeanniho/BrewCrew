// import 'package:firebase_core/firebase_core.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //track auth state change
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  //sign in anon
  Future signInAnon() async {
    try {
      final UserCredential result = await _auth.signInAnonymously();
      final User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      print("auth failed");
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future signUpWithEmailAndPassword(String name, String surname, String phone,
      String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user;
      await DatabaseService(uid: user.uid)
          .addUserDetails(name, surname, phone, user.email);
      await DatabaseService(uid: user.uid).updateUserData(name+" "+surname, "0", 100, "coffee");
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //log out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
