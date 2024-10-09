import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/common/widgets/custom_text_field.dart';
import 'package:journal_web/features/login/data/repositories/login_repo_impl.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String email = '';
    String pass = '';

    return ResponsiveBuilder(builder: (context, sizingInfo) {
      return Container(
        margin: sizingInfo.isMobile ? EdgeInsets.all(8) : EdgeInsets.all(12),
        width: sizingInfo.isMobile ? context.width : context.width * 0.33,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey)]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Login',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: context.height * 0.04),
            CustomTextField(label: 'Email', onChanged: (v) => email = v),
            SizedBox(height: 25),
            CustomTextField(label: 'Password', onChanged: (v) => pass = v),
            SizedBox(height: context.height * 0.04),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginLoadingState) {
                  return CircularProgressIndicator.adaptive();
                }
                return ElevatedButton(
                  onPressed: () {
                    log(email);
                    log(pass);
                    context.read<LoginBloc>().add(LoginInitiateLoginEvent(
                        EmailPassModel(email: email, password: pass)));
                  },
                  child: Text('Login'),
                );
              },
            )
          ],
        ),
      );
    });
  }
}
