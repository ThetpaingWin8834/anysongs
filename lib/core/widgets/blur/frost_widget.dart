// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';

class FrostWidget extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final double sigmaRatio;
  const FrostWidget({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.sigmaRatio = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaRatio, sigmaY: sigmaRatio),
        child: Container(
          // width: 450,
          // height: 250,
          // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 2.5),
              borderRadius: const BorderRadius.all(Radius.circular(25))),
          child: child,
        ),
      ),
    );
  }
}
