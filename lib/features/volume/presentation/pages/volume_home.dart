import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume/volume_bloc.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/presentation/widgets/volume_card.dart';
import 'package:journal_web/routes.dart';

class VolumeHomePage extends StatelessWidget {
  const VolumeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Volumes'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.dashboard + Routes.addVolume);
              },
              icon: Icon(Icons.add),
            )
          ]),
      body: BlocBuilder<VolumeBloc, VolumeState>(
        builder: (context, state) {
          if (state is VolumeInitial) {
            context.read<VolumeBloc>().add(GetVolumesEvent());
          }
          if (state is VolumeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is VolumesLoaded) {
            if (state.volumes.isEmpty) {
              return Center(
                child: Text('No Volumes Available yet'),
              );
            }
            return ListView.builder(
              itemCount: state.volumes.length,
              itemBuilder: (context, index) {
                VolumeModel volume = state.volumes[index];
                return VolumeCard(volume: volume);
              },
            );
          } else if (state is VolumeError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            context.read<VolumeBloc>().add(GetVolumesEvent());
            return Center(child: Text('Unknown error Occured'));
          }
        },
      ),
    );
  }
}
