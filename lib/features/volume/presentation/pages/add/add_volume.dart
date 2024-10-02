import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume/volume_bloc.dart';

class AddVolumePage extends StatefulWidget {
  const AddVolumePage({super.key});

  @override
  State<AddVolumePage> createState() => _AddVolumePageState();
}

class _AddVolumePageState extends State<AddVolumePage> {
  final _formKey = GlobalKey<FormState>();
  VolumeModel volume = VolumeModel(isActive: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Add New Volume'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double horizontalPadding =
              constraints.maxWidth > 600 ? constraints.maxWidth * 0.25 : 16.0;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Volume Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a volume title';
                          }
                          return null;
                        },
                        onChanged: (value) => volume.title = value),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Volume Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a volume number';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onChanged: (value) => volume.volumeNumber = value,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      onChanged: (value) => volume.description = value,
                    ),
                    SizedBox(height: 16),
                    CheckboxListTile(
                      title: Text('Is Active'),
                      value: volume.isActive ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          volume.isActive = value ?? false;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<VolumeBloc>()
                                .add(AddVolumeEvent(volume: volume));
                            Get.back();
                          }
                        },
                        child: Text('Save Volume'),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '* Issues will be added later after creating the volume',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
