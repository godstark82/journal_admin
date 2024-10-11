import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddJournalPage extends StatefulWidget {
  const AddJournalPage({super.key});

  @override
  _AddJournalPageState createState() => _AddJournalPageState();
}

class _AddJournalPageState extends State<AddJournalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _domainController = TextEditingController();
  Uint8List? _imageBytes;
  bool _isLoading = false;
  String? _imageUrl;

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

  void _submitForm() {
    if (_formKey.currentState!.validate() && _imageUrl != null) {
      final newJournal = JournalModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        domain: _domainController.text,
        image: _imageUrl!,
        createdAt: DateTime.now(),
      );

      context.read<JournalBloc>().add(CreateJournalEvent(journal: newJournal));
      Navigator.pop(context);
    } else if (_imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload an image before submitting.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Journal'),
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
        constraints: const BoxConstraints(maxWidth: 600),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildMobileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _buildForm(),
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
          _buildImageUploadButton(),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Add Journal'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadButton() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _pickImage,
          icon: const Icon(Icons.upload),
          label: const Text('Upload Journal Image'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const CircularProgressIndicator()
        else if (_imageBytes != null)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.memory(_imageBytes!, fit: BoxFit.cover),
          )
        else
          const Text('No image selected'),
      ],
    );
  }
}
