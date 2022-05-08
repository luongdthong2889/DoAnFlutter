import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/core/const/data_constants.dart';
import 'package:fitness_flutter/core/service/auth_service.dart';
import 'package:fitness_flutter/core/service/data_service.dart';
import 'package:fitness_flutter/core/service/firebase_cloud_api.dart';
import 'package:fitness_flutter/core/service/user_storage_service.dart';
import 'package:fitness_flutter/data/exercise_data.dart';
import 'package:fitness_flutter/data/user_data.dart';
import 'package:fitness_flutter/data/workout_data.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  List<WorkoutData> workouts = <WorkoutData>[];
  List<ExerciseData> exercises = <ExerciseData>[];
  static final FirebaseAuth auth = FirebaseAuth.instance;
  final userData = UserData.fromFirebase(auth.currentUser);
  final db = FirebaseFirestore.instance;
  int timeSent = 0;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeInitialEvent) {
      workouts = await DataService.getWorkoutsForUser();
      yield WorkoutsGotState(workouts: workouts);
    } else if (event is ReloadImageEvent) {
      String? photoURL = await UserStorageService.readSecureData('image');
      if (photoURL == null) {
        photoURL = AuthService.auth.currentUser?.photoURL;
        photoURL != null
            ? await UserStorageService.writeSecureData('image', photoURL)
            : print('no image');
      }
      yield ReloadImageState(photoURL: photoURL);
    }
  }

  // Future getUserData() async {
  //   var collection = FirebaseFirestore.instance.collection('users');
  //   collection.doc(userData.id).snapshots().listen((docSnapshot) {
  //     if (docSnapshot.exists) {
  //       Map<String, dynamic> data = docSnapshot.data()!;
  //       userData.progressWorkout01 = data['progressWorkout01'];
  //       userData.progressWorkout02 = data['progressWorkout02'];
  //       userData.progressWorkout03 = data['progressWorkout03'];
  //       userData.progressWorkout04 = data['progressWorkout04'];
  //       userData.finishedWorkout01 = data['finishedWorkout01'];
  //       userData.finishedWorkout02 = data['finishedWorkout02'];
  //       userData.finishedWorkout03 = data['finishedWorkout03'];
  //       userData.finishedWorkout04 = data['finishedWorkout04'];
  //       print('?????????????????????????????????????');
  //       finish = [
  //         userData.finishedWorkout01,
  //         userData.finishedWorkout02,
  //         userData.finishedWorkout03,
  //         userData.finishedWorkout04,
  //       ];
  //       print(finish);
  //       count = finish.where((element) => element == 1).length;
  //       print(count);
  //       if (userData.progressWorkout01 < 3 &&
  //           userData.progressWorkout01 >= 1) {
  //         countinprogress += 1;
  //       }
  //       if (userData.progressWorkout02 < 3 &&
  //           userData.progressWorkout02 >= 1) {
  //         countinprogress += 1;
  //       }
  //       if (userData.progressWorkout03 < 3 &&
  //           userData.progressWorkout03 >= 1) {
  //         countinprogress += 1;
  //       }
  //       if (userData.progressWorkout04 < 3 &&
  //           userData.progressWorkout04 >= 1) {
  //         countinprogress += 1;
  //       }
  //       print(countinprogress);
  //     }
  //   });
  // }


  int getProgressPercentage() {
    final completed = workouts
        .where((w) =>
            (w.currentProgress ?? 0) > 0 && w.currentProgress == w.progress)
        .toList();
    final percent01 =
        completed.length.toDouble() / DataConstants.workouts.length.toDouble();
    final percent = (percent01 * 100).toInt();
    return percent;
  }

  int? getFinishedWorkouts() {
    final completedWorkouts =
        workouts.where((w) => w.currentProgress == w.progress).toList();
    return completedWorkouts.length;
  }

  int? getInProgressWorkouts() {
    final completedWorkouts = workouts.where(
        (w) => (w.currentProgress ?? 0) > 0 && w.currentProgress != w.progress);
    return completedWorkouts.length;
  }

  int? getTimeSent() {
    for (final WorkoutData workout in workouts) {
      exercises.addAll(workout.exerciseDataList!);
    }
    final exercise = exercises.where((e) => e.progress == 1).toList();
    exercise.forEach((e) {
      timeSent += e.minutes!;
    });
    return timeSent;
  }
}
