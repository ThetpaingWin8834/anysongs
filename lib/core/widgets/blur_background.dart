// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';

class BlurBackground extends StatelessWidget {
  final Widget child;
  final double blurRadius;
  final EdgeInsetsGeometry? padding;
  final BorderRadius borderRadius;
  final Color? color;
  const BlurBackground({
    Key? key,
    required this.child,
    this.blurRadius = 5,
    this.padding,
    this.borderRadius = BorderRadius.zero,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurRadius,
          sigmaY: blurRadius,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? Colors.grey.shade200.withOpacity(0.3),
          ),
          child: child,
        ),
      ),
    );
  }
}
