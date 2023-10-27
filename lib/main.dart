import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_viewer/pages/image/Image_home.dart';
import 'package:image_viewer/pages/onboarding/login_page.dart';
import 'package:image_viewer/provider/LoginProvider.dart';
import 'package:image_viewer/provider/authentication_provider.dart';
import 'package:provider/provider.dart';

import 'provider/picsum_image_provider.dart';
import 'repo/app_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefsRepository().init();
  FlutterError.onError = (details) {
    // catch the error in remote services like Firebase
    // FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthenticationProvider>(
        create: (_) => AuthenticationProvider()),
    ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
    ChangeNotifierProvider<PicsumImageProvider>(
        create: (_) => PicsumImageProvider())
  ], child: PicsumImageViewerApp()));
}

class PicsumImageViewerApp extends StatelessWidget {
  const PicsumImageViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picsum Image Viewer',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(background: Colors.white)),
      home: Consumer<AuthenticationProvider>(
          builder: (context, authProvider, child) {
        return authProvider.authState == AuthState.LOGGED_OUT ||
                authProvider.authState == AuthState.LOGIN_FAILURE
            ? LoginForm()
            : authProvider.authState == AuthState.LOGGEDIN
                ? PicsumHomePage()
                : LoadingPage();
      }),

      // Unused, but we will declare more routes as we expand the app and write the route logic
      //routes: ,
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
