import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/base_bloc/base_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  FutureOr<void> _tabItemTapped(
    TabItemTap event,
    Emitter<HomeState> emit,
  ) async {
    emit(TabItemChanged(activeViewIndex: event.activeIndex));
  }

  @override
  Future<void> eventHandlerMethod(
    HomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (event is TabItemTap) {
      return _tabItemTapped(event, emit);
    }
  }

  @override
  HomeState getErrorState() {
    return HomeError();
  }
}
