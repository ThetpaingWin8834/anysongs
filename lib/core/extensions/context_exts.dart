import 'dart:ui';

import 'package:anysongs/core/locale/locale.dart';
import 'package:anysongs/core/widgets/blur/blur_background.dart';
import 'package:anysongs/core/widgets/blur/frost_widget.dart';
import 'package:flutter/material.dart';

extension ContextExts on BuildContext {
  ThemeData get themeData => Theme.of(this);
  ColorScheme get colorScheme => themeData.colorScheme;
  TextTheme get textTheme => themeData.textTheme;
  MediaQueryData get mediaQueryData => MediaQuery.of(this);
  Size get size => mediaQueryData.size;
  bool get isDarkMode =>
      MediaQuery.of(this).platformBrightness == Brightness.dark;
  double percentWidthOf(double percent) => size.width * percent;
  double percentHeightOf(double percent) => size.height * percent;
  void showSnackBar(Widget content) {
    ScaffoldMessenger.maybeOf(this)?.showSnackBar(
      SnackBar(content: content),
    );
  }

  void showMaterialBanner(
      {required Widget content, required List<Widget> actions}) {
    ScaffoldMessenger.maybeOf(this)?.showMaterialBanner(
      MaterialBanner(
        content: content,
        actions: actions,
      ),
    );
  }

  void navigateToScreen(Widget screen) {
    Navigator.push(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
        ));
  }

  void showLoadingDialog() {
    showDialog(
      context: this,
      builder: (context) => FrostWidget(
        child: Text(Mylocale.appDescription),
      ),
      barrierColor: Colors.transparent,
    );
  }

  void showSimpleDialog(
    String title,
    String message, {
    List<Widget>? actions,
    bool isDismissable = true,
  }) {
    showAdaptiveDialog(
      barrierDismissible: isDismissable,
      context: this,
      builder: (context) => AlertDialog.adaptive(
        // icon: Image.asset(MyImages.appLogo),
        title: Text(title),
        content: Text(message),
        actions: actions,
      ),
    );
  }

  void showBlurDia({
    String? title,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    showGeneralDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black38,
      barrierLabel: title ?? DateTime.now().toString(),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, _, __) => AlertDialog(
        title: title == null ? null : Text(title),
        content: content,
        elevation: 2,
        actions: actions,
      ),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 3 * anim1.value, sigmaY: 3 * anim1.value),
        child: child,
      ),
      context: this,
    );
  }

  void showBlurDialog({String? title, required List<Widget> childs}) {
    showDialog(
      context: this,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: BlurBackground(
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(10),
          // color: context.colorScheme.background.withOpacity(0.7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Text(
                  title,
                  style: context.textTheme.titleLarge,
                ),
              ...childs,
            ],
          ),
        ),
      ),
    );
  }
}
