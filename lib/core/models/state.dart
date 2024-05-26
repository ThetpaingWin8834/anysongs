import 'package:flutter/material.dart';

@immutable
sealed class MyState<T> {}

final class InitialState<T> extends MyState<T> {}

final class LoadingState<T> extends MyState<T> {}

final class ErrorState<T> extends MyState<T> {
  final Object? error;

  ErrorState({required this.error});
}

final class SuccessState<T> extends MyState<T> {
  final T data;

  SuccessState({required this.data});
}
