import 'package:flutter/foundation.dart';

class LoginProvider extends ChangeNotifier {
  String? username = "";
  String? password = "";

  bool emailError = false;
  bool passwordError = false;

  String emailErrorMessage = "";
  String passwordErrorMessage = "";

  bool showPassword = false;


  LoginProvider();

  usernameChanged(String email) {
    username = email;
    emailError = emailvalidator(username);
    if (emailError == true) {
      emailErrorMessage = "Invalid email";
    }
    notifyListeners();
  }

  passwordChanged(String pass) {
    password = pass;
    validatePassword();
    notifyListeners();
  }

  passwordToggle(bool toggle){
    showPassword = toggle;
    notifyListeners();
  }

  bool emailvalidator(String) {
    return isValidEmail();
  }

  bool passwordValidator(String password) {
    return false;
  }

  bool isValidEmail() {
    // https://stackoverflow.com/a/61512807
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(username!);
  }

  validatePassword() {
// https://stackoverflow.com/a/19605207

    RegExp regex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$');
    if (password!.isEmpty) {
      passwordError = true;
      passwordErrorMessage = 'Please enter password';
    } else {
      if (!regex.hasMatch(password!)) {
        passwordError = true;
        passwordErrorMessage = 'Enter valid password';
      } else {
        print("pass not err");
        passwordError = false;
        passwordErrorMessage = "";
      }
    }
  }
}
