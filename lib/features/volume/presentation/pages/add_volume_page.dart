import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume_bloc.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddVolumePage extends StatefulWidget {
  const AddVolumePage({super.key});

  @override
  _AddVolumePageState createState() => _AddVolumePageState();
}

class _AddVolumePageState extends State<AddVolumePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _volumeNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isActive = true;
  JournalModel? _selectedJournal;

  @override
  void initState() {
    super.initState();
    context.read<JournalBloc>().add(GetAllJournalEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Volume'),
        backgroundColor: Colors.blue,
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
            return _buildDesktopView();
          } else {
            return _buildMobileView();
          }
        },
      ),
    );
  }

  Widget _buildDesktopView() {
    return Center(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
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
                return Center(child: const LinearProgressIndicator());
              } else if (state is JournalsLoaded) {
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
          Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.teal),
              const SizedBox(width: 16),
              const Text('Is Active'),
              const Spacer(),
              Switch(
                value: _isActive,
                onChanged: (bool value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                activeColor: Colors.teal,
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _submitForm,
            icon: const Icon(Icons.add),
            label: const Text('Add Volume'),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final volume = VolumeModel(
        id: '', // This will be generated by the backend
        title: _titleController.text,
        journalId: _selectedJournal!.id,
        volumeNumber: _volumeNumberController.text,
        createdAt: DateTime.now(),
        description: _descriptionController.text,
        isActive: _isActive,
      );

      context.read<VolumeBloc>().add(CreateVolumeEvent(volume: volume));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Volume added successfully')),
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
