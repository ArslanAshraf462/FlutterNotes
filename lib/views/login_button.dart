import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../dialogs/generic_dilog.dart';

typedef OnLoginTap = void Function(
  String email,
  String password,
);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTap onLoginTap;
  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final email = emailController.text;
        final password = passwordController.text;
        if (email.isEmpty || password.isEmpty) {
          showGenericDialog(
            context: context,
            title: emailOrPasswordEmptyDialogTitle,
            content: emailOrPasswordEmptyDescription,
            optionBuilder: () => {
              ok: true,
            },
          );
        } else {
          onLoginTap(
            email,
            password,
          );
        }
      },
      child: const Text(login),
    );
  }
}
