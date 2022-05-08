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
      isLoading = true;
    });
  }

  Future getData() async {
    var docsnapshot = await db.collection("users").doc(userData.id).get();
    if (docsnapshot.exists) {
      Map<String, dynamic> data = docsnapshot.data()!;
      userData.workoutsfinishedWO1 = data['workoutsfinishedWO1'];
      userData.workoutsfinishedWO2 = data['workoutsfinishedWO2'];
      userData.workoutsfinishedWO3 = data['workoutsfinishedWO3'];
      userData.workoutsfinishedWO4 = data['workoutsfinishedWO4'];
      userData.currentProgressUserWO1 = data['currentProgressUserWO1'];
      userData.currentProgressUserWO2 = data['currentProgressUserWO2'];
      userData.currentProgressUserWO3 = data['currentProgressUserWO3'];
      userData.currentProgressUserWO4 = data['currentProgressUserWO4'];
      userData.time = data['time'];
      userData.percentwo = data['percentwo'];
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  TextConstants.workouts,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
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
    print(isLoading);
    fetchData(workoutData);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: WorkoutCard(workout: workoutData),
    );
  }

  fetchData(WorkoutData workoutData) {
    if (workoutData.id == "1") {
      workoutData.currentProgress = userData.currentProgressUserWO1 ?? 0;
    }
    if (workoutData.id == "2") {
      workoutData.currentProgress = userData.currentProgressUserWO2 ?? 0;
    }
    if (workoutData.id == "3") {
      workoutData.currentProgress = userData.currentProgressUserWO3 ?? 0;
    }
    if (workoutData.id == "4") {
      workoutData.currentProgress = userData.currentProgressUserWO4 ?? 0;
    }
    isLoading = true;
  }
}
