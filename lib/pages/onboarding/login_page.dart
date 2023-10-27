import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_viewer/provider/LoginProvider.dart';
import 'package:provider/provider.dart';

import '../../../provider/authentication_provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Login Page"),
          centerTitle: true,
        ),
        body: Align(
          alignment: const Alignment(0, -1 / 3),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Image.asset(
                  "assets/lennar.png",
                  fit: BoxFit.contain,
                )),
                _UsernameInput(),
                const Padding(padding: EdgeInsets.all(12)),
                _PasswordInput(),
                const Padding(padding: EdgeInsets.all(12)),
                _LoginButton(),
                Consumer<AuthenticationProvider>(
                  builder: (context, authProvider, child) {
                    return authProvider.authState == AuthState.LOGIN_FAILURE
                        ? Text("Login Failed")
                        : SizedBox.shrink();
                  },
                )
              ],
            ),
          ),
        ));
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginprovider, child) {
        return TextField(
          key: const Key('email-Input'),
          onChanged: (username) =>
              Provider.of<LoginProvider>(context, listen: false)
                  .usernameChanged(username),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green)),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
            labelText: 'E-mail',
            errorText: loginprovider.emailError != true
                ? loginprovider.emailErrorMessage
                : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginprovider, child) {
        return TextField(
          key: const Key('password-input'),
          onChanged: (password) =>
              Provider.of<LoginProvider>(context, listen: false)
                  .passwordChanged(password),
          obscureText: !loginprovider.showPassword ? true : false,
          textInputAction: TextInputAction.done ,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(loginprovider.showPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                loginprovider
                    .passwordToggle(
                        !loginprovider.showPassword);
              },
            ),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green)),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
            labelText: 'Password',
            errorText: loginprovider.passwordError == true
                ? loginprovider.passwordErrorMessage
                : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) {
        return authProvider.authState == AuthState.LOGGING_IN
            ? const CircularProgressIndicator()
            : Center(
                child: ElevatedButton(
                    onPressed: () {
                      Provider.of<AuthenticationProvider>(context,
                              listen: false)
                          .login(
                        context.read<LoginProvider>().username!,
                        context.read<LoginProvider>().password!,
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.black),
                    )),
              );
      },
    );
  }
}
