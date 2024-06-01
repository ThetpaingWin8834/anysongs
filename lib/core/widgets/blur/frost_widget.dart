// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';

class FrostWidget extends StatelessWidget {
  final Widget child;
  const FrostWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                // width: 450,
                // height: 250,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 2.5),
                    borderRadius: const BorderRadius.all(Radius.circular(25))),
                child: child,
              ),
            ),
          ),
        ),
        // child,
      ],
    );
  }
}
