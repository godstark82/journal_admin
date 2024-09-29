import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  ArticleModel article = ArticleModel();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Article'),
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          double horizontalPadding = sizingInformation.isDesktop ? 200.0 : 16.0;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      onChanged: (v) => article.title = v,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Document Type',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a document type';
                        }
                        return null;
                      },
                      onChanged: (v) => article.documentType = v,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      onChanged: (v) => article.abstractString = v,
                      decoration: InputDecoration(
                        labelText: 'Abstract',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an abstract';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Main Subjects (comma-separated)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter main subjects';
                        }
                        return null;
                      },
                      onChanged: (v) => article.mainSubjects =
                          v.split(',').map((e) => e.trim()).toList(),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      onChanged: (v) => article.keywords =
                          v.split(',').map((e) => e.trim()).toList(),
                      decoration: InputDecoration(
                        labelText: 'Keywords (comma-separated)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter keywords';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      onChanged: (v) => article.references =
                          v.split(',').map((e) => e.trim()).toList(),
                      decoration: InputDecoration(
                        labelText: 'References (comma-separated)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter references';
                        }
                        return null;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      onChanged: (v) => article.pdf = v,
                      decoration: InputDecoration(
                        labelText: 'PDF url',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a pdf url';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                allowMultiple: false,
                              );

                              if (result != null) {
                                setState(() {
                                  _isUploading = true;
                                });

                                PlatformFile file = result.files.first;
                                String fileName =
                                    '${DateTime.now().millisecondsSinceEpoch}_${file.name}';

                                try {
                                  // Upload to Firebase Storage
                                  Reference ref = FirebaseStorage.instance
                                      .ref()
                                      .child('article_images/$fileName');
                                  UploadTask uploadTask =
                                      ref.putData(file.bytes!);
                                  TaskSnapshot snapshot = await uploadTask;
                                  String downloadUrl =
                                      await snapshot.ref.getDownloadURL();

                                  // Save the download URL to the article
                                  setState(() {
                                    article.image = downloadUrl;
                                    _isUploading = false;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Image uploaded successfully')),
                                  );
                                } catch (e) {
                                  print('Error uploading image: $e');
                                  setState(() {
                                    _isUploading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Failed to upload image')),
                                  );
                                }
                              }
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
                                _isUploading ? 'Uploading...' : 'Upload Image'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              minimumSize: Size(120, 36),
                            ),
                          ),
                          if (article.image != null) ...[
                            SizedBox(height: 16),
                            Text(
                              'Image uploaded',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Image.network(
                              article.image!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (article.image != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Image uploaded: ${article.image}'),
                      ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<ArticleBloc>()
                              .add(ArticleAddEvent(article: article));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Article published successfully!'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Submit Article'),
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

  @override
  void dispose() {
    super.dispose();
  }
}
