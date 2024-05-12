// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyStreamWidget<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(T) child;
  final Widget? onLoading;
  final Widget Function(Object?)? onError;
  const MyStreamWidget({
    Key? key,
    required this.stream,
    required this.child,
    this.onLoading,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return onError?.call(snapshot.error) ?? const SizedBox.shrink();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return onLoading ?? const SizedBox.shrink();
        } else {
          return child(snapshot.data as T);
        }
      },
    );
  }
}
