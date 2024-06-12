// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants/images.dart';

class MyArtWorkWidget2 extends StatelessWidget {
  final Uri? uri;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadiusGeometry borderRadius;
  const MyArtWorkWidget2({
    super.key,
    required this.uri,
    this.errorWidget,
    this.width,
    this.height,
    this.fit,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: uri == null
          ? Image.asset(
              MyImages.appLogo,
              width: width,
              height: height,
              fit: BoxFit.fill,
            )
          : Image.file(
              File.fromUri(uri!),
              width: width,
              height: height,
              fit: fit,
            ),
    );
  }
}
