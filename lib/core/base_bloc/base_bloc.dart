import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<E, S extends ErrorState> extends Bloc<E, S> {
  BaseBloc(super.initialState) {
    on<E>(
      _eventHandler,
    );
  }

  FutureOr<void> _eventHandler(E event, Emitter<S> emit) async {
    try {
      await eventHandlerMethod(event, emit);
    } on DioException catch (dioError) {
      debugPrint(
          '============ eventHandler DioException: ${dioError.response?.data}');
      debugPrint('$dioError');
      try {
        if (dioError.response?.statusCode == 422) {
          final Map<String, dynamic> err =
              dioError.response?.data as Map<String, dynamic>;
          emit(getErrorState()
            ..errorCode = dioError.response?.statusCode ?? 0
            ..errorMsg = err['error'].toString());
        } else if (dioError.response?.statusCode == 401) {
          emit(getErrorState()
            ..errorCode = dioError.response?.statusCode ?? 0
            ..errorMsg = 'Unauthorized'
            ..forceLogOut = true);
        } else {
          emit(getErrorState()
            ..errorCode = dioError.response?.statusCode ?? 0
            ..errorMsg = dioError.message ?? 'Something Went Wrong');
        }
      } catch (err) {
        debugPrint('============ eventHandler catch block: $err');
        emit(getErrorState()
          ..errorCode = 0
          ..errorMsg = err.toString());
      }
    } catch (err) {
      debugPrint('============ eventHandler catch block: $err');
      emit(getErrorState()
        ..errorCode = 0
        ..errorMsg = err.toString()
        ..forceLogOut = true);
    }
  }

  Future<void> eventHandlerMethod(E event, Emitter<S> emit);

  S getErrorState();
}

abstract class ErrorState {
  int errorCode = 0;
  String errorMsg = '';
  bool forceLogOut = false;
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(
      Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    debugPrint(
        'onTransition -- bloc: ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('onError -- bloc: ${bloc.runtimeType}, error: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    debugPrint('onClose -- bloc: ${bloc.runtimeType}');
  }
}
