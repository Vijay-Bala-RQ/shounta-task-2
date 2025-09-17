part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class TabItemTap extends HomeEvent {
  TabItemTap({
    required this.activeIndex,
  });

  final int activeIndex;
}
