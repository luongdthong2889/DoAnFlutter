import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/core/const/color_constants.dart';
import 'package:fitness_flutter/core/const/data_constants.dart';
import 'package:fitness_flutter/core/const/path_constants.dart';
import 'package:fitness_flutter/core/const/text_constants.dart';
import 'package:fitness_flutter/core/service/data_service.dart';
import 'package:fitness_flutter/core/service/firebase_cloud_api.dart';
import 'package:fitness_flutter/data/exercise_data.dart';
import 'package:fitness_flutter/data/user_data.dart';
import 'package:fitness_flutter/data/workout_data.dart';
import 'package:fitness_flutter/screens/common_widgets/fitness_button.dart';
import 'package:fitness_flutter/screens/start_workout/bloc/start_workout_bloc.dart';
import 'package:fitness_flutter/screens/start_workout/page/start_workout_page.dart';
import 'package:fitness_flutter/screens/start_workout/widget/start_workout_video.dart';
import 'package:fitness_flutter/screens/workout_details_screen/bloc/workout_details_bloc.dart'
    as workout_bloc;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartWorkoutContent extends StatefulWidget {
  final WorkoutData workout;
  final ExerciseData exercise;
  final ExerciseData? nextExercise;

  StartWorkoutContent({
    required this.workout,
    required this.exercise,
    required this.nextExercise,
  });

  @override
  State<StartWorkoutContent> createState() => _StartWorkoutContentState();
}

class _StartWorkoutContentState extends State<StartWorkoutContent> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  static final FirebaseAuth auth = FirebaseAuth.instance;
  final userData = UserData.fromFirebase(auth.currentUser);

  List<WorkoutData> wo = DataConstants.workouts.toList();

  final db = FirebaseFirestore.instance;

  static var inprogress = [];
  static int timeSent = 0;
  static int percent = 0;
  List<WorkoutData> workouts = <WorkoutData>[];

  List<ExerciseData> exercises = <ExerciseData>[];

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
    inprogress = [
      userData.currentProgressUserWO1,
      userData.currentProgressUserWO2,
      userData.currentProgressUserWO3,
      userData.currentProgressUserWO4,
    ];
    print(inprogress);
    if (inprogress.where((element) => element < 3 && element > 0).length == 1) {
      userData.percentwo = 25;
      percent = 25;
    } else if (inprogress
            .where((element) => element < 3 && element > 0)
            .length ==
        2) {
      userData.percentwo = 50;
      percent = 50;
    } else if (inprogress
            .where((element) => element < 3 && element > 0)
            .length ==
        3) {
      userData.percentwo = 75;
      percent = 75;
    } else if (inprogress
            .where((element) => element < 3 && element > 0)
            .length ==
        4) {
      userData.percentwo = 100;
      percent = 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: ColorConstants.white,
      child: SafeArea(
        child: _createDetailedExercise(context),
      ),
    );
  }

  Widget _createDetailedExercise(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createBackButton(context),
          const SizedBox(height: 23),
          _createVideo(context),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(children: [
              _createTitle(),
              const SizedBox(height: 9),
              _createDescription(),
              const SizedBox(height: 30),
              _createSteps(),
            ]),
          ),
          _createTimeTracker(context),
        ],
      ),
    );
  }

  Widget _createBackButton(BuildContext context) {
    final bloc = BlocProvider.of<StartWorkoutBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 8),
      child: GestureDetector(
        child: BlocBuilder<StartWorkoutBloc, StartWorkoutState>(
          builder: (context, state) {
            return Row(
              children: [
                Image(image: AssetImage(PathConstants.back)),
                const SizedBox(width: 17),
                Text(
                  TextConstants.back,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            );
          },
        ),
        onTap: () {
          bloc.add(BackTappedEvent());
        },
      ),
    );
  }

  Widget _createVideo(BuildContext context) {
    final bloc = BlocProvider.of<StartWorkoutBloc>(context);
    return Container(
      height: 264,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: ColorConstants.white),
      child: StartWorkoutVideo(
        exercise: widget.exercise,
        onPlayTapped: (time) async {
          bloc.add(PlayTappedEvent(time: time));
        },
        onPauseTapped: (time) {
          bloc.add(PauseTappedEvent(time: time));
        },
      ),
    );
  }

  Widget _createTitle() {
    return Text(widget.exercise.title ?? "",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
  }

  Widget _createDescription() {
    return Text(widget.exercise.description ?? "",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500));
  }

  Widget _createSteps() {
    return Column(
      children: [
        for (int i = 0; i < widget.exercise.steps!.length; i++) ...[
          Step(number: "${i + 1}", description: widget.exercise.steps![i]),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _createTimeTracker(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorConstants.white,
      child: Column(
        children: [
          widget.nextExercise != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      TextConstants.nextExercise,
                      style: TextStyle(
                        color: ColorConstants.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.nextExercise?.title ?? "",
                      style: TextStyle(
                        color: ColorConstants.textBlack,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6.5),
                    Icon(Icons.access_time, size: 20),
                    const SizedBox(width: 6.5),
                    Text(
                        '${widget.nextExercise!.minutes! > 10 ? widget.nextExercise!.minutes : '0${widget.nextExercise!.minutes}'}:00')
                    // BlocBuilder<StartWorkoutBloc, StartWorkoutState>(
                    //   buildWhen: (_, currState) => currState is PlayTimerState || currState is PauseTimerState,
                    //   builder: (context, state) {
                    //     return StartWorkoutTimer(
                    //       time: bloc.time,
                    //       isPaused: !(state is PlayTimerState),
                    //     );
                    //   },
                    // ),
                  ],
                )
              : SizedBox.shrink(),
          const SizedBox(height: 18),
          _createButton(context),
        ],
      ),
    );
  }

  Widget _createButton(BuildContext context) {
    final bloc = BlocProvider.of<workout_bloc.WorkoutDetailsBloc>(context);
    return FitnessButton(
      title: widget.nextExercise != null
          ? TextConstants.next
          : TextConstants.finished,
      onTap: () async {
        print(
            widget.exercise.id.toString() + 'okayyyyyyyyyyyyyyyyyyyyyyyyyyyyy');
        print(widget.workout.id.toString() +
            'okayyyyyyyyyyyyyyyyyyyyyyyyyyyyy6666666666666');
        if (widget.nextExercise == null) {
          if (widget.workout.id == "1") {
            List<ExerciseData>? exercisesList = bloc.workout.exerciseDataList;
            int currentExerciseIndex = exercisesList!.indexOf(widget.exercise);
            userData.currentProgressUserWO1 = currentExerciseIndex + 1;
            userData.workoutsfinishedWO1 = 1;
            if (widget.exercise.id == "1.3") {
              timeSent = timeSent + widget.exercise.minutes!.toInt();
              userData.time = timeSent;
            }
            // print(userData.percentwo);
            // wo.forEach((element) {

            //   print(element.currentProgress);
            // });
            // print(timeSent);
            FirebaseFirestore.instance
                .collection('users')
                .doc(userData.id)
                .update({
              'currentProgressUserWO1': currentExerciseIndex + 1,
              'workoutsfinishedWO1': userData.workoutsfinishedWO1,
              'time': userData.time,
              'percentwo': percent,
            });
          }
          if (widget.workout.id == "2") {
            List<ExerciseData>? exercisesList = bloc.workout.exerciseDataList;
            int currentExerciseIndex = exercisesList!.indexOf(widget.exercise);
            userData.currentProgressUserWO2 = currentExerciseIndex + 1;
            userData.workoutsfinishedWO2 = 1;
            if (widget.exercise.id == "2.3") {
              timeSent = timeSent + widget.exercise.minutes!.toInt();
              userData.time = timeSent;
            }
            FirebaseFirestore.instance
                .collection('users')
                .doc(userData.id)
                .update({
              'currentProgressUserWO2': currentExerciseIndex + 1,
              'workoutsfinishedWO2': userData.workoutsfinishedWO2,
              'time': userData.time,
              'percentwo': percent,
            });
          }
          if (widget.workout.id == "3") {
            List<ExerciseData>? exercisesList = bloc.workout.exerciseDataList;
            int currentExerciseIndex = exercisesList!.indexOf(widget.exercise);
            userData.currentProgressUserWO3 = currentExerciseIndex + 1;
            userData.workoutsfinishedWO3 = 1;
            if (widget.exercise.id == "3.3") {
              timeSent = timeSent + widget.exercise.minutes!.toInt();
              userData.time = timeSent;
            }
            FirebaseFirestore.instance
                .collection('users')
                .doc(userData.id)
                .update({
              'currentProgressUserWO3': currentExerciseIndex + 1,
              'workoutsfinishedWO3': userData.workoutsfinishedWO3,
              'time': userData.time,
              'percentwo': percent,
            });
          }
          if (widget.workout.id == "4") {
            List<ExerciseData>? exercisesList = bloc.workout.exerciseDataList;
            int currentExerciseIndex = exercisesList!.indexOf(widget.exercise);
            userData.currentProgressUserWO4 = currentExerciseIndex + 1;
            userData.workoutsfinishedWO4 = 1;
            if (widget.exercise.id == "4.3") {
              timeSent = timeSent + widget.exercise.minutes!.toInt();
              userData.time = timeSent;
            }
            FirebaseFirestore.instance
                .collection('users')
                .doc(userData.id)
                .update({
              'currentProgressUserWO4': currentExerciseIndex + 1,
              'workoutsfinishedWO4': userData.workoutsfinishedWO4,
              'time': userData.time,
              'percentwo': percent,
            });
          }
        }
        if (widget.nextExercise != null) {
          List<ExerciseData>? exercisesList = bloc.workout.exerciseDataList;
          int currentExerciseIndex = exercisesList!.indexOf(widget.exercise);
          print(currentExerciseIndex.toString() +
              'okayyyyyyyyyyyyyyyyyyyyyyyyyyyyy2222222222222222222222222222');
          await _saveWorkout(currentExerciseIndex);

          if (widget.workout.id == "1") {
            List<ExerciseData>? exercisesList = bloc.workout.exerciseDataList;
            int currentExerciseIndex = exercisesList!.indexOf(widget.exercise);
            userData.currentProgressUserWO1 = currentExerciseIndex + 1;
            if (userData.currentProgressUserWO1 < 3 &&
                userData.currentProgressUserWO1 > 0) {
              userData.workoutsfinishedWO1 = 0;
            }
            if (widget.exercise.id == "1.1") {
              timeSent = timeSent + widget.exercise.minutes!.toInt();
              userData.time = timeSent;
            }
            if (widget.exercise.id == "1.2") {
              timeSent = timeSent + widget.exercise.minutes!.toInt();
              userData.time = timeSent;
            }
            // print(timeSent);
            FirebaseFirestore.instance
                .collection('users')
                .doc(userData.id)
                .update({
              'currentProgressUserWO1': currentExerciseIndex + 1,
              'workoutsfinishedWO1': userData.workoutsfinishedWO1,
              'time': userData.time,
            });
          }
          if (widget.workout.id == "2") {
            List<ExerciseData>? exercisesList = bloc.workout.exerciseDataList;
            int currentExerciseIndex = exercisesList!.indexOf(widget.exercise);
            userData.currentProgressUserWO2 = currentExerciseIndex + 1;
            if (userData.currentProgressUserWO2 < 3 &&
                userData.currentProgressUserWO2 > 0) {
              userData.workoutsfinishedWO2 = 0;
            }
            if (widget.exercise.id == "2.1") {
              timeSent = timeSent + widget.exercise.minutes!.toInt();
              userData.time = timeSent;
            }
            if (widget.exercise.id == "2.2") {
              timeSent = timeSent + widget.exercise.minutes!.toInt();
              userData.time = timeSent;
            }
            FirebaseFirestore.instance
                .collection('users')
                .doc(userData.id)
                .update({
              'currentProgressUserWO2': currentExerciseIndex + 1,
              'workoutsfinishedWO2': userData.workoutsfinishedWO2,
              'time': userData.time,
            });
          }
          if (widget.workout.id == "3") {
            List<ExerciseData>? exercisesList = bloc.workout.exerciseDataList;
            int currentExerciseIndex = exercisesList!.indexOf(widget.exercise);
            userData.currentProgressUserWO3 = currentExerciseIndex + 1;
            if (userData.currentProgressUserWO3 < 3 &&
                userData.currentProgressUserWO3 > 0) {
              userData.workoutsfinishedWO3 = 0;
            }
            if (widget.exercise.id == "3.1") {
              userData.time = timeSent;
              timeSent = timeSent + widget.exercise.minutes!.toInt();
            }
            if (widget.exercise.id == "3.2") {
              userData.time = timeSent;
              timeSent = timeSent + widget.exercise.minutes!.toInt();
            }
            FirebaseFirestore.instance
                .collection('users')
                .doc(userData.id)
                .update({
              'currentProgressUserWO3': currentExerciseIndex + 1,
              'workoutsfinishedWO3': userData.workoutsfinishedWO3,
              'time': userData.time,
            });
          }
          if (widget.workout.id == "4") {
            List<ExerciseData>? exercisesList = bloc.workout.exerciseDataList;
            int currentExerciseIndex = exercisesList!.indexOf(widget.exercise);
            userData.currentProgressUserWO4 = currentExerciseIndex + 1;
            if (userData.currentProgressUserWO4 < 3 &&
                userData.currentProgressUserWO4 > 0) {
              userData.workoutsfinishedWO4 = 0;
            }
            if (widget.exercise.id == "4.1") {
              userData.time = timeSent;
              timeSent = timeSent + widget.exercise.minutes!.toInt();
            }
            if (widget.exercise.id == "4.2") {
              userData.time = timeSent;
              timeSent = timeSent + widget.exercise.minutes!.toInt();
            }
            FirebaseFirestore.instance
                .collection('users')
                .doc(userData.id)
                .update({
              'currentProgressUserWO4': currentExerciseIndex + 1,
              'workoutsfinishedWO4': userData.workoutsfinishedWO4,
              'time': userData.time,
            });
          }
          if (currentExerciseIndex < exercisesList.length - 1) {
            bloc.add(workout_bloc.StartTappedEvent(
              workout: widget.workout,
              index: currentExerciseIndex + 1,
              isReplace: true,
            ));
          }
        } else {
          await _saveWorkout(widget.workout.exerciseDataList!.length - 1);

          Navigator.pop(context, widget.workout);
        }
      },
    );
  }

  Future<void> _saveWorkout(int exerciseIndex) async {
    if (widget.workout.currentProgress! < exerciseIndex + 1) {
      widget.workout.currentProgress = exerciseIndex + 1;
    }
    widget.workout.exerciseDataList![exerciseIndex].progress = 1;

    await DataService.saveWorkout(widget.workout);
  }
}

class Step extends StatelessWidget {
  final String number;
  final String description;

  Step({required this.number, required this.description});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorConstants.primaryColor.withOpacity(0.12),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorConstants.primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(description)),
      ],
    );
  }
}
