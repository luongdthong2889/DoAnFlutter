part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class ReloadImageState extends HomeState {
  final String? photoURL;

  ReloadImageState({
    required this.photoURL,
  });
}

class WorkoutsGotState extends HomeState {
  final List<WorkoutData> workouts;

  WorkoutsGotState({
    required this.workouts,
  });
}