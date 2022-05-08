import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/core/service/firebase_cloud_api.dart';
import 'package:fitness_flutter/data/user_data.dart';
import 'package:fitness_flutter/screens/home/bloc/home_bloc.dart';
import 'package:fitness_flutter/screens/home/widget/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  
  static final FirebaseAuth auth = FirebaseAuth.instance;
  final userData = UserData.fromFirebase(auth.currentUser);
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    getDoc();
    return Scaffold(
      body: _buildContext(context),
    );
  }

  BlocProvider<HomeBloc> _buildContext(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc(),
      child: BlocConsumer<HomeBloc, HomeState>(
        buildWhen: (_, currState) =>
            currState is HomeInitial || currState is WorkoutsGotState,
        builder: (context, state) {
          final bloc = BlocProvider.of<HomeBloc>(context);
          if (state is HomeInitial) {
            bloc.add(HomeInitialEvent());
            bloc.add(ReloadImageEvent());
          }
          return HomeContent(workouts: bloc.workouts);
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
      ),
    );
  }

  Future getDoc() async {
    var a = await db.collection('users').doc(userData.id).get();
    if(!a.exists){
      pustUserDataInit();
    }
  }

  pustUserDataInit(){
    userData.progressWorkout01 = 0;
    userData.progressWorkout02 = 0;
    userData.progressWorkout03 = 0;
    userData.progressWorkout04 = 0;
    userData.finishedWorkout01 = 0;
    userData.finishedWorkout02 = 0;
    userData.finishedWorkout03 = 0;
    userData.finishedWorkout04 = 0;
    userData.time = 0;
    userData.percentProgressWorkout = 0;
    FirebaseApi.createUserData(userData);
  }
}