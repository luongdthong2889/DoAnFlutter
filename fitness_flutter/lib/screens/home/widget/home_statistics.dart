import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/core/const/color_constants.dart';
import 'package:fitness_flutter/core/const/path_constants.dart';
import 'package:fitness_flutter/core/const/text_constants.dart';
import 'package:fitness_flutter/core/service/firebase_cloud_api.dart';
import 'package:fitness_flutter/data/user_data.dart';
import 'package:fitness_flutter/data/workout_data.dart';
import 'package:fitness_flutter/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStatistics extends StatefulWidget {
  HomeStatistics({Key? key}) : super(key: key);

  @override
  State<HomeStatistics> createState() => _HomeStatisticsState();
}

class _HomeStatisticsState extends State<HomeStatistics> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  static var finish = [];
  static var inprogress = [];
  static final FirebaseAuth auth = FirebaseAuth.instance;
  final userData = UserData.fromFirebase(auth.currentUser);
  static int timesent = 0;
  final db = FirebaseFirestore.instance;
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
    finish = [
      userData.workoutsfinishedWO1,
      userData.workoutsfinishedWO2,
      userData.workoutsfinishedWO3,
      userData.workoutsfinishedWO4,
    ];
    inprogress = [
      userData.currentProgressUserWO1,
      userData.currentProgressUserWO2,
      userData.currentProgressUserWO3,
      userData.currentProgressUserWO4,
    ];
    timesent = userData.time ?? 0; 
    print(inprogress);
    print(inprogress.where((element) => element < 3 && element > 0).length);
    print(userData.time);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createComletedWorkouts(context, bloc),
          _createColumnStatistics(bloc),
        ],
      ),
    );
  }

  // Future getUserData() async {
  Widget _createComletedWorkouts(BuildContext context, HomeBloc bloc) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(15),
      height: 200,
      width: screenWidth * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorConstants.white,
        boxShadow: [
          BoxShadow(
            color: ColorConstants.textBlack.withOpacity(0.12),
            blurRadius: 5.0,
            spreadRadius: 1.1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Image(
                image: AssetImage(
                  PathConstants.finished,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  TextConstants.finished,
                  style: TextStyle(
                    color: ColorConstants.textBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            ],
          ),
          Text(
            // '${bloc.getFinishedWorkouts()}',
            '${finish.where((element) => element == 1).length}',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: ColorConstants.textBlack,
            ),
          ),
          Text(
            TextConstants.completedWorkouts,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorConstants.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createColumnStatistics(HomeBloc bloc) {
    return Column(
      children: [
        DataWorkouts(
          icon: PathConstants.inProgress,
          title: TextConstants.inProgress,
          // count: bloc.getInProgressWorkouts() ?? 0,
          count: inprogress.where((element) => element < 3 && element > 0).length,
          text: TextConstants.workouts,
        ),
        const SizedBox(height: 20),
        DataWorkouts(
          icon: PathConstants.timeSent,
          title: TextConstants.timeSent,
          // count: bloc.getTimeSent() ?? 0,
          count: userData.time ?? timesent,
          text: TextConstants.minutes,
        ),
      ],
    );
  }
}

class DataWorkouts extends StatelessWidget {
  final String icon;
  final String title;
  final int count;
  final String text;

  DataWorkouts({
    required this.icon,
    required this.title,
    required this.count,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 90,
      width: screenWidth * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorConstants.white,
        boxShadow: [
          BoxShadow(
            color: ColorConstants.textBlack.withOpacity(0.12),
            blurRadius: 5.0,
            spreadRadius: 1.1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Image(image: AssetImage(icon)),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.textBlack,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.textBlack,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
