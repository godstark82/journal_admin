import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditJournalPage extends StatefulWidget {
  const EditJournalPage({super.key});

  @override
  _EditJournalPageState createState() => _EditJournalPageState();
}

class _EditJournalPageState extends State<EditJournalPage> {
  final journalId = Get.parameters['journalId']!;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _domainController;
  Uint8List? _imageBytes;
  bool _isLoading = false;
  String? _imageUrl;

  @override
  void initState() {
    log(journalId);
    super.initState();
    _titleController = TextEditingController();
    _domainController = TextEditingController();
    context.read<JournalBloc>().add(GetJournalByIdEvent(id: journalId));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields before uploading an image.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      setState(() {
        _imageBytes = image;
      });
      await _uploadImage();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _uploadImage() async {
    if (_imageBytes == null) return;

    final Reference storageRef = FirebaseStorage.instance.ref().child('journal_images/${_titleController.text}${_domainController.text}${DateTime.now().toIso8601String()}.png');
    final UploadTask uploadTask = storageRef.putData(_imageBytes!);

    await uploadTask.whenComplete(() async {
      _imageUrl = await storageRef.getDownloadURL();
    });
  }

  void _submitForm(JournalModel journal) {
    if (_formKey.currentState!.validate()) {
      final updatedJournal = journal.copyWith(
        title: _titleController.text,
        domain: _domainController.text,
        image: _imageUrl ?? journal.image,
      );
      context
          .read<JournalBloc>()
          .add(UpdateJournalEvent(journal: updatedJournal));
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Journal'),
      ),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          if (state is JournalByIdLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JournalByIdLoaded) {
            final journal = state.journal;
            _titleController.text = journal.title;
            _domainController.text = journal.domain;
            _imageUrl = journal.image;
            return ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) {
                  return _buildDesktopView(journal);
                } else {
                  return _buildMobileView(journal);
                }
              },
            );
          } else if (state is JournalError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  Widget _buildDesktopView(JournalModel journal) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: _buildForm(journal),
      ),
    );
  }

  Widget _buildMobileView(JournalModel journal) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _buildForm(journal),
    );
  }

  Widget _buildForm(JournalModel journal) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _domainController,
            decoration: const InputDecoration(
              labelText: 'Domain',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a domain';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          _buildImageSection(journal),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _submitForm(journal),
            child: const Text('Update Journal'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(JournalModel journal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Image:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (_imageUrl != null)
          Image.network(_imageUrl!, height: 200)
        else
          const Text('No image uploaded'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _isLoading ? null : _pickImage,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Change Image'),
        ),
      ],
    );
  }
}
