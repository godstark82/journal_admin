import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/login/presentation/widgets/login_widget.dart';
import 'package:journal_web/features/login/presentation/widgets/signup_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
        appBar: AppBar(
          title: const Text('ADMIN - JOURNAL TITLE'),
          centerTitle: true,
          elevation: 1,
        ),
        body: SizedBox(
          height: context.height,
          width: context.width,
          child: context.width > 750
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginWidget(),
                    SignupWidget(),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      LoginWidget(),
                      SignupWidget(),
                    ],
                  ),
                ),
        ));
  }
}
