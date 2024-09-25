import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:journal_web/core/common/widgets/custom_text_field.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: context.height * 0.075),
            CustomTextField(label: 'Username', onChanged: (v) {}),
            SizedBox(height: 25),
            CustomTextField(label: 'Password', onChanged: (v) {}),
            SizedBox(height: context.height * 0.05),
            GFButton(
              icon: Icon(Icons.login),
              onPressed: null,
              text: 'Login',
            )
          ],
        ),
      );
    });
  }
}
