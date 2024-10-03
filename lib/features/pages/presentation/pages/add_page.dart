import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/pages/data/models/page_model.dart';
import 'package:journal_web/features/pages/presentation/bloc/pages_bloc.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _websiteController = TextEditingController();
  final HtmlEditorController _contentController = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Page Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a page name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(
                  labelText: 'Website',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a website';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Content',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              HtmlEditor(
                otherOptions: OtherOptions(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: _contentController,
                htmlEditorOptions: HtmlEditorOptions(
                  hint: 'Enter your content here...',
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  defaultToolbarButtons: [
                    FontButtons(),
                    ColorButtons(),
                    ParagraphButtons(),
                    InsertButtons(),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _savePage,
                child: Text('Save Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _savePage() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final website = _websiteController.text;
      final content = await _contentController.getText();

      final PageModel page = PageModel(
        name: name,
        website: website,
        content: content,
        id: '1',
        insertDate: DateTime.now(),
      );

      context.read<PagesBloc>().add(AddPageEvent(page: page));

      Get.back(); // Navigate back to the previous screen
      Get.snackbar('Success', 'Page added successfully');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
}
