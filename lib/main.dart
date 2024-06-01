import 'dart:async';

import 'package:anysongs/core/constants/images.dart';
import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/locale/locale.dart';
import 'package:anysongs/core/theme/theme.dart';
import 'package:anysongs/core/utils/debug.dart';
import 'package:anysongs/core/widgets/anim/overshooting_anim.dart';
import 'package:anysongs/features/home/all_songs/cubit/all_songs_cubit.dart';
import 'package:anysongs/features/home/home_screen.dart';
import 'package:anysongs/features/home/playlist/cubit/playlist_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.sirius.anysongs',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('my', 'MM'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AllSongsCubit(),
        ),
        BlocProvider(
          create: (context) => PlaylistCubit(),
        ),
      ],
      child: MaterialApp(
        title: Mylocale.appDescription,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const _PermissionChecker(),
      ),
    );
  }
}

class _PermissionChecker extends StatefulWidget {
  const _PermissionChecker();

  @override
  State<_PermissionChecker> createState() => _PermissionCheckerState();
}

class _PermissionCheckerState extends State<_PermissionChecker>
    with WidgetsBindingObserver {
  final animFinished = Completer<bool>();
  bool shouldResumeCall = false;
  int _requestCount = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    checkPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: context.colorScheme.surface,
          systemNavigationBarIconBrightness:
              context.mediaQueryData.platformBrightness,
        ),
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (shouldResumeCall) {
        checkPermission();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onAnimFinished() => setState(() {
        animFinished.complete(true);
      });
  void goAppSetting() {
    shouldResumeCall = false;
    context.showSimpleDialog(
      Mylocale.appName,
      Mylocale.permissionDenied,
      isDismissable: false,
      actions: [
        TextButton(
          onPressed: () {
            openAppSettings().then((isSettingOpenable) {
              if (!isSettingOpenable) {
                context.showSimpleDialog(
                  Mylocale.appName,
                  Mylocale.cannotOpenSettings,
                  isDismissable: false,
                );
              }
            });
            shouldResumeCall = true;
            Navigator.pop(context);
          },
          child: Text(Mylocale.openSettings),
        ),
      ],
    );
  }

  void checkPermission() async {
    try {
      final permission =
          await OnAudioQuery().queryDeviceInfo().then((deviceModel) {
        return deviceModel.version < 33 ? Permission.storage : Permission.audio;
      });
      final status = await permission.status;
      mp(status.name);
      if (status == PermissionStatus.granted) {
        animFinished.future.then((_) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
        });
      } else {
        _requestCount++;
        if (_requestCount >= 2) {
          return goAppSetting();
        }
        shouldResumeCall = false;

        permission.request().then((status) {
          if (status == PermissionStatus.granted) {
            animFinished.future.then((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ));
            });
          } else if (status == PermissionStatus.denied) {
            return checkPermission();
          } else if (status == PermissionStatus.permanentlyDenied) {
            return goAppSetting();
          }
        });
      }
    } catch (e) {
      mp(e);
      Future.delayed(const Duration(seconds: 1)).then((_) {
        context.showSimpleDialog(Mylocale.appName, e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              goAppSetting();
              // checkPermission();
            },
            child: SizedBox(
              width: double.maxFinite,
              child: Text(
                Mylocale.appName,
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          OverShootingAnim(
            onAnimDone: onAnimFinished,
            duration: const Duration(milliseconds: 2000),
            child: Image.asset(
              MyImages.appLogo,
              width: context.percentWidthOf(0.35),
              height: context.percentHeightOf(0.35),
            ),
          ),
          Text(Mylocale.appDescription),
        ],
      ),
    );
  }
}
