import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/core/const/color_constants.dart';
import 'package:fitness_flutter/core/const/data_constants.dart';
import 'package:fitness_flutter/core/const/text_constants.dart';
import 'package:fitness_flutter/data/user_data.dart';
import 'package:fitness_flutter/data/workout_data.dart';
import 'package:fitness_flutter/screens/workouts/bloc/workouts_bloc.dart';
import 'package:fitness_flutter/screens/workouts/widget/workout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutContent extends StatefulWidget {
  WorkoutContent({Key? key}) : super(key: key);

  @override
  State<WorkoutContent> createState() => _WorkoutContentState();
}

class _WorkoutContentState extends State<WorkoutContent> {
  @override
  void initState() {
    loadData();
    super.initState();
    getData();
  }

  bool isLoading = false;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  final userData = UserData.fromFirebase(auth.currentUser);
  final db = FirebaseFirestore.instance;
  loadData() {
    setState(() {
      isLoading = false;
    });
    setState(() {
      getData();
      isLoading = true;
    });
  }

  Future getData() async {
    var docsnapshot = await db.collection("user_data").doc(userData.id).get();
    if (docsnapshot.exists) {
      Map<String, dynamic> data = docsnapshot.data()!;
      userData.finishedWorkout01 = data['finishedWorkout01'];
      userData.finishedWorkout02 = data['finishedWorkout02'];
      userData.finishedWorkout03 = data['finishedWorkout03'];
      userData.finishedWorkout04 = data['finishedWorkout04'];
      userData.progressWorkout01 = data['progressWorkout01'];
      userData.progressWorkout02 = data['progressWorkout02'];
      userData.progressWorkout03 = data['progressWorkout03'];
      userData.progressWorkout04 = data['progressWorkout04'];
      userData.time = data['time'];
      userData.percentProgressWorkout = data['percentProgressWorkout'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.homeBackgroundColor,
      height: double.infinity,
      width: double.infinity,
      child: _createHomeBody(context),
    );
  }

  Widget _createHomeBody(BuildContext context) {
    final bloc = BlocProvider.of<WorkoutsBloc>(context);
    return BlocBuilder<WorkoutsBloc, WorkoutsState>(
      buildWhen: (_, currState) => currState is ReloadWorkoutsState,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    TextConstants.workouts,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 100),
                TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('user_data')
                        .doc(userData.id)
                        .update({
                      'progressWorkout01': 0,
                      'progressWorkout02': 0,
                      'progressWorkout03': 0,
                      'progressWorkout04': 0,
                      'finishedWorkout01': 0,
                      'finishedWorkout02': 0,
                      'finishedWorkout03': 0,
                      'finishedWorkout04': 0,
                      'time': 0,
                      'percentProgressWorkout': 0,
                    });
                  },
                  child: Text(
                    "Reset progress",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primaryColor,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 5),
              Expanded(
                child: ListView(
                  children:
                      bloc.workouts.map((e) => _createWorkoutCard(e)).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _createWorkoutCard(WorkoutData workoutData) {
    //print(isLoading);
    //fetchData(workoutData);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FutureBuilder(
          future: fetchData(workoutData),
          builder: (context, snapshot) {
            if(isLoading == true && snapshot.hasData){
              return WorkoutCard( workout: workoutData);
            }
              return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Future fetchData(WorkoutData workoutData) => Future.delayed(Duration(seconds: 1), () {
    if (workoutData.id == "1") {
      if (userData.progressWorkout01 != null) {
         workoutData.currentProgress = userData.progressWorkout01 ?? 0;
      }
    }
    if (workoutData.id == "2") {
      if (userData.progressWorkout02 != null) {
        workoutData.currentProgress = userData.progressWorkout02 ?? 0;
      }
    }
    if (workoutData.id == "3") {
      if (userData.progressWorkout03 != null) {
        workoutData.currentProgress = userData.progressWorkout03 ?? 0;
      }
    }
    if (workoutData.id == "4") {
      if (userData.progressWorkout04 != null) {
        workoutData.currentProgress =  userData.progressWorkout04 ?? 0;
      }
    }
    isLoading = true;
    return workoutData;
      });

  // Future fetchData(WorkoutData workoutData)  async {
  //   if (workoutData.id == "1") {
  //     if (userData.progressWorkout01 != null) {
  //        workoutData.currentProgress = await userData.progressWorkout01 ?? 0;
  //     }
  //   }
  //   if (workoutData.id == "2") {
  //     if (userData.progressWorkout02 != null) {
  //       workoutData.currentProgress = await userData.progressWorkout02 ?? 0;
  //     }
  //   }
  //   if (workoutData.id == "3") {
  //     if (userData.progressWorkout03 != null) {
  //       workoutData.currentProgress = await userData.progressWorkout03 ?? 0;
  //     }
  //   }
  //   if (workoutData.id == "4") {
  //     if (userData.progressWorkout04 != null) {
  //       workoutData.currentProgress = await userData.progressWorkout04 ?? 0;
  //     }
  //   }
  //   isLoading = true;
  //   return workoutData;
  // }
}
