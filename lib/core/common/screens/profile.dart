import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
              onPressed: () {
                context.read<LoginBloc>().add(LogoutEvent());
              },
              icon: Icon(Icons.logout, color: Colors.red))
        ],
      ),
      body: Center(
        child: Text('Current Role: ${context.read<LoginBloc>().state.role}'),
      ),
    );
  }
}
