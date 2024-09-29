import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';

class EditArticlePage extends StatefulWidget {
  const EditArticlePage({super.key, required this.article});
  final ArticleModel article;

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isUploading = false;
  ArticleModel get article => widget.article;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController abstractController = TextEditingController();
  final TextEditingController authorsController = TextEditingController();
  final TextEditingController keywordsController = TextEditingController();
  final TextEditingController documentTypeController = TextEditingController();
  final TextEditingController mainSubjectsController = TextEditingController();
  final TextEditingController referencesController = TextEditingController();
  final TextEditingController pdfController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing article data
    titleController.text = article.title ?? '';
    abstractController.text = article.abstractString ?? '';
    authorsController.text = article.authors?.join(', ') ?? '';
    keywordsController.text = article.keywords?.join(', ') ?? '';
    documentTypeController.text = article.documentType ?? '';
    mainSubjectsController.text = article.mainSubjects?.join(', ') ?? '';
    referencesController.text = article.references?.join('\n') ?? '';
    pdfController.text = article.pdf ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Article'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0)  ,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context
                      .read<ArticleBloc>()
                      .add(ArticleUpdateEvent(article: article));
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Update Article'),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ArticleBloc, ArticleState>(
        listener: (context, state) {
          if (state is ArticleUpdateArticleState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Article updated successfully!')),
            );
            Navigator.pop(context);
          } else if (state is ArticleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                constraints: BoxConstraints(maxWidth: 800),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          article.title = value;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: abstractController,
                        decoration: InputDecoration(labelText: 'Abstract'),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an abstract';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          article.abstractString = value;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: authorsController,
                        decoration: InputDecoration(
                          labelText: 'Authors (comma-separated)',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter at least one author';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          article.authors =
                              value.split(',').map((e) => e.trim()).toList();
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: keywordsController,
                        decoration: InputDecoration(
                          labelText: 'Keywords (comma-separated)',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter at least one keyword';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          article.keywords =
                              value.split(',').map((e) => e.trim()).toList();
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: documentTypeController,
                        decoration: InputDecoration(labelText: 'Document Type'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a document type';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          article.documentType = value;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: mainSubjectsController,
                        decoration: InputDecoration(
                            labelText: 'Main Subjects (comma-separated)'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter at least one main subject';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          article.mainSubjects =
                              value.split(',').map((e) => e.trim()).toList();
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: referencesController,
                        decoration: InputDecoration(labelText: 'References'),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter references';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          article.references =
                              value.split('\n').map((e) => e.trim()).toList();
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: pdfController,
                        decoration: InputDecoration(labelText: 'PDF URL'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a PDF URL';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          article.pdf = value;
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Image upload logic (similar to add_article_page.dart)
                          // ...
                        },
                        icon: _isUploading
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Icon(Icons.image, size: 18),
                        label: Text(
                            _isUploading ? 'Uploading...' : 'Update Image'),
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size(120, 36),
                        ),
                      ),
                      if (article.image != null) ...[
                        SizedBox(height: 16),
                        Text(
                          'Current Image',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Image.network(
                          article.image!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
