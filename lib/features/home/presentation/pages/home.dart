import 'package:flutter/material.dart';
import 'package:journal_web/core/const/login_const.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Current Role : ${LoginConst.currentRole}'),
      ),
    );
  }
}
