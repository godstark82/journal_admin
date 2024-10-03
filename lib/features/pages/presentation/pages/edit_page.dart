import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:journal_web/features/pages/data/models/page_model.dart';
import 'package:journal_web/features/pages/presentation/bloc/pages_bloc.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final pageId = Get.parameters['pageId']!;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _pageNameController;
  late TextEditingController _websiteController;
  late HtmlEditorController _contentController;

  @override
  void initState() {
    super.initState();
    _pageNameController = TextEditingController();
    _websiteController = TextEditingController();
    _contentController = HtmlEditorController();

    _loadPageData();
  }

  Future<void> _loadPageData() async {
    context.read<PagesBloc>().add(GetSinglePageEvent(id: pageId));
  }

  Future<void> _savePage() async {
    if (_formKey.currentState!.validate()) {
      final content = await _contentController.getText();
      final updatedPage = PageModel(
        id: pageId,
        name: _pageNameController.text,
        insertDate: DateTime.now(),
        website: _websiteController.text,
        content: content,
      );
      context.read<PagesBloc>().add(UpdatePageEvent(page: updatedPage));
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Page'),
      ),
      body: BlocConsumer<PagesBloc, PagesState>(
        listener: (context, state) {
          if (state is SinglePageErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is SinglePageLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is SinglePageLoadedState) {
            _pageNameController.text = state.page.name;
            _websiteController.text = state.page.website;
            _contentController.setText(state.page.content);

            return SingleChildScrollView(
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
                    HtmlEditor(
                      controller: _contentController,
                      htmlEditorOptions: HtmlEditorOptions(
                        hint: 'Enter your content here...',
                        initialText: state.page.content,
                      ),
                      htmlToolbarOptions: HtmlToolbarOptions(
                        defaultToolbarButtons: [
                          FontButtons(),
                          ColorButtons(),
                          ListButtons(),
                          ParagraphButtons(),
                          InsertButtons(),
                          OtherButtons(),
                        ],
                      ),
                      otherOptions: OtherOptions(height: 400),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _savePage,
                      child: Text('Save Page'),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageNameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
}
