import 'package:anysongs/core/theme/custom/text_field_theme.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    inputDecorationTheme: MyTextFieldThemes.lightInputDecorationTheme,
  );
  static final ThemeData darkTheme = ThemeData.dark(
    useMaterial3: true,
  );
}
