// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/images.dart';

class MyArtWorkWidget2 extends StatelessWidget {
  final Uri? uri;
  final Widget? errorWidget;
  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  const MyArtWorkWidget2(
      {Key? key,
      required this.uri,
      this.errorWidget,
      this.borderRadius,
      this.width = 50,
      this.height = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(width),
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
              fit: BoxFit.cover,
            ),
    );
  }
}
