// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class OverShootingAnim extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onAnimDone;

  const OverShootingAnim({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.onAnimDone,
  }) : super(key: key);

  @override
  State<OverShootingAnim> createState() => _OverShootingAnimState();
}

class _OverShootingAnimState extends State<OverShootingAnim>
    with SingleTickerProviderStateMixin {
  late final animationController =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(
          parent: animationController, curve: Curves.elasticOut));
  @override
  void initState() {
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimDone?.call();
      }
    });
    super.initState();
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: GestureDetector(
          onTap: () {
            animationController.forward();
          },
          child: widget.child),
    );
  }
}
