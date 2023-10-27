import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_viewer/repo/app_repository.dart';
import 'package:image_viewer/services/picsum_api_service.dart';
import 'package:provider/provider.dart';

abstract class AuthInterface {
  void login(String username, String password);
  void logout();
  void checkLoginSession();
}

enum AuthState { LOGGEDIN, LOGGED_OUT, LOADING, LOGGING_IN, LOGIN_FAILURE }

class AuthenticationProvider extends ChangeNotifier implements AuthInterface {
  AuthState? authState = AuthState.LOADING;

  AuthenticationProvider() {
    checkLoginSession();
  }

  @override
  void login(String username, String password) async {
    print("logingggg");
    authState = AuthState.LOADING;
    notifyListeners();
    var loginresp =  PicsumApiService().mockLogin(username.trim(), password.trim());
    if (loginresp == true) {
      localRepository.setLogin();
      authState = AuthState.LOGGEDIN;
      notifyListeners();
    print(32);
    } else {
      authState = AuthState.LOGIN_FAILURE;
      notifyListeners();
    }
    notifyListeners();
  }

  @override
  void logout() async {
    authState = AuthState.LOADING;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 150));
    localRepository.clearCredentials();
    authState = AuthState.LOGGED_OUT;
    notifyListeners();
  }

  @override
  void checkLoginSession() async {
    await Future.delayed(Duration(seconds: 2));
    bool isLogged = localRepository.isLoggedIn;

    if (isLogged == true) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final lastLoginTime = localRepository.lastLoginTime();
      if (currentTime - lastLoginTime! < 3600000) {
        authState = AuthState.LOGGEDIN;
      } else {
        authState = AuthState.LOGGED_OUT;
      }
    } else {
      authState = AuthState.LOGGED_OUT;
    }
    notifyListeners();
  }
}
