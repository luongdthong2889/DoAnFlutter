import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  static Future<void> createUserData(UserData userData) async {
    final db = FirebaseFirestore.instance;

    db.collection("users").doc(userData.id).set(userData.toJson());
  }

  static Future<void> getUsetData(UserData userData) async {
    var collection = FirebaseFirestore.instance.collection('users');
    collection.doc(userData.id).snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        userData.progressWorkout01 = data['progressWorkout01'];
        userData.progressWorkout02 = data['progressWorkout02'];
        userData.progressWorkout03 = data['progressWorkout03'];
        userData.progressWorkout04 = data['progressWorkout04'];
        userData.finishedWorkout01 = data['finishedWorkout01'];
        userData.finishedWorkout02 = data['finishedWorkout02'];
        userData.finishedWorkout03 = data['finishedWorkout03'];
        userData.finishedWorkout04 = data['finishedWorkout04'];
        print('?????????????????????????????????????');
      }
    });
  }
}
