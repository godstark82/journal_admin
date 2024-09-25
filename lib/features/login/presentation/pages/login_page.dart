import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/login/presentation/widgets/login_widget.dart';
import 'package:journal_web/features/login/presentation/widgets/signup_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('ADMIN - JOURNAL TITLE'),
          centerTitle: true,
          elevation: 1,
        ),
        body: ResponsiveBuilder(builder: (context, sizingInfo) {
          if (sizingInfo.isMobile || sizingInfo.isTablet) {
            return ListView(
              children: [
                LoginWidget(),
                SignupWidget(),
              ],
            );
          } else {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              height: context.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: LoginWidget()),
                  Expanded(child: SignupWidget()),
                ],
              ),
            );
          }
        }));
  }
}
