import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume_bloc.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditVolumePage extends StatefulWidget {
  const EditVolumePage({super.key});

  @override
  _EditVolumePageState createState() => _EditVolumePageState();
}

class _EditVolumePageState extends State<EditVolumePage> {
  final volumeId = Get.parameters['volumeId']!;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _volumeNumberController;
  late TextEditingController _descriptionController;
  bool _isActive = true;
  JournalModel? _selectedJournal;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _volumeNumberController = TextEditingController();
    _descriptionController = TextEditingController();
    context.read<VolumeBloc>().add(GetVolumeEvent(volumeId: volumeId));
    context.read<JournalBloc>().add(GetAllJournalEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Volume'),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<VolumeBloc, VolumeState>(
        builder: (context, state) {
          if (state is VolumeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VolumeLoaded) {
            final volume = state.volume;
            _titleController.text = volume.title;
            _volumeNumberController.text = volume.volumeNumber;
            _descriptionController.text = volume.description;
            _isActive = volume.isActive;
            return ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) {
                  return _buildDesktopView(volume);
                } else {
                  return _buildMobileView(volume);
                }
              },
            );
          } else if (state is VolumeError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildDesktopView(VolumeModel volume) {
    return Center(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(volume),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileView(VolumeModel volume) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildForm(volume),
      ),
    );
  }

  Widget _buildForm(VolumeModel volume) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Volume Title',
              icon: Icon(Icons.title, color: Colors.blue),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          BlocBuilder<JournalBloc, JournalState>(
            builder: (context, state) {
              if (state is JournalsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is JournalsLoaded) {
                _selectedJournal ??= state.journals
                    .firstWhere((journal) => journal.id == volume.journalId);
                return DropdownButtonFormField<JournalModel>(
                  value: _selectedJournal,
                  decoration: const InputDecoration(
                    labelText: 'Select Journal',
                    icon: Icon(Icons.book, color: Colors.green),
                  ),
                  items: state.journals.map((journal) {
                    return DropdownMenuItem(
                      value: journal,
                      child: Text(journal.title),
                    );
                  }).toList(),
                  onChanged: (JournalModel? newValue) {
                    setState(() {
                      _selectedJournal = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a journal';
                    }
                    return null;
                  },
                );
              } else {
                return const Text('Failed to load journals');
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _volumeNumberController,
            decoration: const InputDecoration(
              labelText: 'Volume Number',
              icon: Icon(Icons.format_list_numbered, color: Colors.orange),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a volume number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              icon: Icon(Icons.description, color: Colors.purple),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SwitchListTile(
                title: const Text('Is Active'),
                value: _isActive,
                onChanged: (bool value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                secondary: const Icon(Icons.check_circle_outline, color: Colors.teal),
                activeColor: Colors.teal,
              );
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _submitForm(volume),
            icon: const Icon(Icons.save),
            label: const Text('Update Volume'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm(VolumeModel volume) {
    if (_formKey.currentState!.validate()) {
      final updatedVolume = VolumeModel(
        id: volume.id,
        title: _titleController.text,
        journalId: _selectedJournal!.id,
        volumeNumber: _volumeNumberController.text,
        createdAt: volume.createdAt,
        description: _descriptionController.text,
        isActive: _isActive,
      );

      context.read<VolumeBloc>().add(UpdateVolumeEvent(volume: updatedVolume));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Volume updated successfully')),
      );

      Get.back();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _volumeNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
