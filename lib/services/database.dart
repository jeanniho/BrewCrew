import 'package:brew_crew/modals/brew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //firestore collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection("brews");
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  //create user collection
  Future addUserDetails(
      String name, String surname, String phone, String email) async {
    return await users.doc(uid).set({
      "name": name,
      "surname": surname,
      "phone": phone,
      "email": email,
      "initial": (name[0] + surname[0]).toUpperCase(),
    });
  }

  //create/update user data
  Future updateUserData(
      String name, String sugar, int strength, String drink) async {
    return await brewCollection.doc(uid).set({
      "name": name,
      "sugar": sugar,
      "strength": strength,
      "drink": drink,
    });
  }

  //return current user initials
  Widget getInitial() {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Text('An Error has occured'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return Text(
          snapshot.data.get('initial'),
        );
      },
    );
  }

  //get user email
  Widget getEmail() {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Text('An Error has occured'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return Text(
          snapshot.data.get('email'),
        );
      },
    );
  }

  //get user name
  Widget getName() {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Text('An Error has occured'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return Text(
          snapshot.data.get('name') +
              " " +
              snapshot.data.get('surname') +
              "\n" +
              snapshot.data.get('phone'),
        );
      },
    );
  }

  //get a list of brews
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
        name: doc.data()["name"] ?? "",
        sugar: doc.data()["sugar"] ?? "0",
        strength: doc.data()["strength"] ?? 0,
        drink: doc.data()["drink"] ?? "",
      );
    }).toList();
  }

  //get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //get user data
  UserData _userDataFromSnapeshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data()["name"],
        sugar: snapshot.data()["sugar"],
        strength: snapshot.data()["strength"],
        drink: snapshot.data()["drink"]);
  }

  //get user data stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapeshot);
  }
}
