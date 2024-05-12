// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyRotatingWidget extends StatelessWidget {
  final Widget child;
  final AnimationController animationController;
  const MyRotatingWidget({
    Key? key,
    required this.child,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animation =
        Tween<double>(begin: 0, end: 2 * 3.142).animate(animationController);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Transform.rotate(
        angle: animation.value,
        child: child,
      ),
    );
  }
}
