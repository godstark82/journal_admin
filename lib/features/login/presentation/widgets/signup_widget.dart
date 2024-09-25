import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:journal_web/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignupWidget extends StatelessWidget {
  const SignupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      return Container(
        margin: sizingInfo.isMobile ? EdgeInsets.all(8) : EdgeInsets.all(12),
        width: sizingInfo.isMobile ? context.width : context.width * 0.33,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Register',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: context.height * 0.05),
            Card(
                child: ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: Text('NEW AUTHOR'),
                    subtitle: Text(
                        'Register as new Author to submit manuscript and enjoy author services.'),
                    onTap: () {
                      Get.toNamed(Routes.authorSignup);
                    })),
            SizedBox(height: 10),
            Card(
                child: ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: Text('NEW REVIEWER'),
                    subtitle: Text(
                        'Register as Reviewer to participate in journal peer-review process?'),
                    onTap: () {
                      Get.toNamed(Routes.reviewerSignup);
                    })),
            SizedBox(height: 10),
            Card(
                child: ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: Text('NEW EDITOR'),
                    isThreeLine: false,
                    subtitle: Text(
                        'Interested to join our journal editorial network, Register as Editor to start International collaboration.'),
                    onTap: () {
                      Get.toNamed(Routes.editorSignup);
                    })),
            SizedBox(height: context.height * 0.05),
          ],
        ),
      );
    });
  }
}
