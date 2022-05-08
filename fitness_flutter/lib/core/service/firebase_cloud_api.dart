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
        userData.currentProgressUserWO1 = data['currentProgressUserWO1'];
        userData.currentProgressUserWO2 = data['currentProgressUserWO2'];
        userData.currentProgressUserWO3 = data['currentProgressUserWO3'];
        userData.currentProgressUserWO4 = data['currentProgressUserWO4'];
        userData.workoutsfinishedWO1 = data['workoutsfinishedWO1'];
        userData.workoutsfinishedWO2 = data['workoutsfinishedWO2'];
        userData.workoutsfinishedWO3 = data['workoutsfinishedWO3'];
        userData.workoutsfinishedWO4 = data['workoutsfinishedWO4'];
        print('?????????????????????????????????????');
      }
    });
  }
}
