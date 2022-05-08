import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/data/workout_data.dart';
import 'dart:convert';

class UserData {
  String? id;
  String? name;
  String? photo;
  String? mail;
  int? currentProgressUserWO1;
  int? workoutsfinishedWO1;
  int? currentProgressUserWO2;
  int? workoutsfinishedWO2;
  int? currentProgressUserWO3;
  int? workoutsfinishedWO3;
  int? currentProgressUserWO4;
  int? workoutsfinishedWO4;
  int? time;
  int? percentwo;
  List<WorkoutData>? workouts;

  UserData({
    required this.name,
    required this.photo,
    required this.mail,
    required this.workouts,
    this.id,
    this.currentProgressUserWO1,
    this.workoutsfinishedWO1,
    this.currentProgressUserWO2,
    this.workoutsfinishedWO2,
    this.currentProgressUserWO3,
    this.workoutsfinishedWO3,
    this.currentProgressUserWO4,
    this.workoutsfinishedWO4,
    this.time,
    this.percentwo,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    percentwo = json['percentwo'];
    currentProgressUserWO1 = json['currentProgressUserWO1'];
    workoutsfinishedWO1 = json['workoutsfinishedWO1'];
    currentProgressUserWO2 = json['currentProgressUserWO2'];
    workoutsfinishedWO2 = json['workoutsfinishedWO2'];
    currentProgressUserWO3 = json['currentProgressUserWO3'];
    workoutsfinishedWO3 = json['workoutsfinishedWO3'];
    currentProgressUserWO4 = json['currentProgressUserWO4'];
    workoutsfinishedWO4 = json['workoutsfinishedWO4'];
    name = json['name'];
    photo = json['photo'];
    mail = json['mail'];
    if (json['workouts'] != null) {
      List<WorkoutData> workouts = [];
      json['workouts'].forEach((v) {
        workouts.add(new WorkoutData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['percentwo'] = this.percentwo;
    data['currentProgressUserWO1'] = this.currentProgressUserWO1;
    data['workoutsfinishedWO1'] = this.workoutsfinishedWO1;
    data['currentProgressUserWO2'] = this.currentProgressUserWO2;
    data['workoutsfinishedWO2'] = this.workoutsfinishedWO2;
    data['currentProgressUserWO3'] = this.currentProgressUserWO3;
    data['workoutsfinishedWO3'] = this.workoutsfinishedWO3;
    data['currentProgressUserWO4'] = this.currentProgressUserWO4;
    data['workoutsfinishedWO4'] = this.workoutsfinishedWO4;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['mail'] = this.mail;
    if (this.workouts != null) {
      data['workouts'] = this.workouts!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static fromFirebase(User? user) {
    return user != null
        ? UserData(
            id: user.uid,
            name: user.displayName ?? "",
            photo: user.photoURL ?? "",
            mail: user.email ?? "",
            workouts: [],
          )
        : [];
  }

  String toJsonString() {
    final str = json.encode(this.toJson());
    return str;
  }
}
