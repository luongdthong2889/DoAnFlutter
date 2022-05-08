import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/data/workout_data.dart';
import 'dart:convert';

class UserData {
  String? id;
  String? name;
  String? photo;
  String? mail;
  int? progressWorkout01;
  int? finishedWorkout01;
  int? progressWorkout02;
  int? finishedWorkout02;
  int? progressWorkout03;
  int? finishedWorkout03;
  int? progressWorkout04;
  int? finishedWorkout04;
  int? time;
  int? percentProgressWorkout;
  List<WorkoutData>? workouts;

  UserData({
    required this.name,
    required this.photo,
    required this.mail,
    required this.workouts,
    this.id,
    this.progressWorkout01,
    this.finishedWorkout01,
    this.progressWorkout02,
    this.finishedWorkout02,
    this.progressWorkout03,
    this.finishedWorkout03,
    this.progressWorkout04,
    this.finishedWorkout04,
    this.time,
    this.percentProgressWorkout,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    percentProgressWorkout = json['percentProgressWorkout'];
    progressWorkout01 = json['progressWorkout01'];
    finishedWorkout01 = json['finishedWorkout01'];
    progressWorkout02 = json['progressWorkout02'];
    finishedWorkout02 = json['finishedWorkout02'];
    progressWorkout03 = json['progressWorkout03'];
    finishedWorkout03 = json['finishedWorkout03'];
    progressWorkout04 = json['progressWorkout04'];
    finishedWorkout04 = json['finishedWorkout04'];
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
    data['percentProgressWorkout'] = this.percentProgressWorkout;
    data['progressWorkout01'] = this.progressWorkout01;
    data['finishedWorkout01'] = this.finishedWorkout01;
    data['progressWorkout02'] = this.progressWorkout02;
    data['finishedWorkout02'] = this.finishedWorkout02;
    data['progressWorkout03'] = this.progressWorkout03;
    data['finishedWorkout03'] = this.finishedWorkout03;
    data['progressWorkout04'] = this.progressWorkout04;
    data['finishedWorkout04'] = this.finishedWorkout04;
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
