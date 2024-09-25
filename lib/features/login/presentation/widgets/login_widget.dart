import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Center(child: Text('Login')),
    );
  }
}
