// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/widgets/blur_background.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  final double size;
  const Loading({
    Key? key,
    this.size = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlurBackground(
        padding: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(8),
        child: LoadingAnimationWidget.staggeredDotsWave(
            color: context.colorScheme.primary, size: size),
      ),
    );
  }
}
