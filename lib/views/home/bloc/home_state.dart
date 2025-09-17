part of 'home_bloc.dart';

class HomeState extends ErrorState {
  HomeState({
    this.activeViewIndex = 1,
  });

  int activeViewIndex;
}

class HomeInitial extends HomeState {}

class TabItemChanged extends HomeState {
  TabItemChanged({required super.activeViewIndex});
}

class HomeError extends HomeState {}
