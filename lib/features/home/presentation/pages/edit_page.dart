import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final String? pageId;

  const EditPage({super.key, this.pageId});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _pageNameController;
  late TextEditingController _websiteController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _pageNameController = TextEditingController();
    _websiteController = TextEditingController();
    _contentController = TextEditingController();

    if (widget.pageId != null) {
      _loadPageData();
    }
  }

  Future<void> _loadPageData() async {
    // TODO: Implement method to load existing page data
    // You'll need to add a method in AdminServices to fetch page data by ID
    // Then populate the controllers with the fetched data
  }

  Future<void> _savePage() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement method to save/update page data
      // You'll need to add methods in AdminServices to save/update page data
      // Use widget.pageId to determine if it's a new page or an update
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageId == null ? 'Create Page' : 'Edit Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _pageNameController,
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
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
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

  @override
  void dispose() {
    _pageNameController.dispose();
    _websiteController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
