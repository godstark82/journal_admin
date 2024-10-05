import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume_bloc.dart';
import 'package:journal_web/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:journal_web/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditArticlePage extends StatefulWidget {
  const EditArticlePage({super.key});

  @override
  _EditArticlePageState createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  final String articleId = Get.parameters['articleId'] ?? '';

  final _formKey = GlobalKey<FormState>();
  late String title = '';
  late String documentType = '';
  late String abstractString = '';
  late List<String> mainSubjects = [];
  late List<String> keywords = [];
  late List<String> references = [];
  late String pdf = '';
  late String image = '';
  String? selectedJournalId;
  String? selectedVolumeId;
  String? selectedIssueId;

  @override
  void initState() {
    super.initState();
    context.read<ArticleBloc>().add(GetArticleByIdEvent(id: articleId));
    context.read<JournalBloc>().add(GetAllJournalEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Article'),
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticleByIdLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ArticleByIdLoadedState) {
            final article = state.article;
            title = article.title;
            documentType = article.documentType;
            abstractString = article.abstractString;
            mainSubjects = article.mainSubjects;
            keywords = article.keywords;
            references = article.references;
            pdf = article.pdf;
            image = article.image;
            selectedJournalId = article.journalId;
            selectedVolumeId = article.volumeId;
            selectedIssueId = article.issueId;

            context
                .read<VolumeBloc>()
                .add(GetVolumesByJournalIdEvent(journalId: selectedJournalId!));
            context
                .read<IssueBloc>()
                .add(GetIssueByVolumeIdEvent(selectedVolumeId!));

            return ResponsiveBuilder(
              builder: (context, sizingInformation) {
                double horizontalPadding =
                    sizingInformation.isDesktop ? 200.0 : 16.0;
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
                          BlocBuilder<JournalBloc, JournalState>(
                            builder: (context, state) {
                              if (state is JournalsLoaded) {
                                return DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Select Journal',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedJournalId,
                                  items: state.journals.map((journal) {
                                    return DropdownMenuItem<String>(
                                      value: journal.id,
                                      child: Text(journal.title),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedJournalId = newValue;
                                      selectedVolumeId = null;
                                      selectedIssueId = null;
                                    });
                                    if (newValue != null) {
                                      context.read<VolumeBloc>().add(
                                          GetVolumesByJournalIdEvent(
                                              journalId: newValue));
                                    }
                                  },
                                );
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                          SizedBox(height: 16),
                          BlocBuilder<VolumeBloc, VolumeState>(
                            builder: (context, state) {
                              if (state is VolumeLoadedByJournalId) {
                                return DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Select Volume',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedVolumeId,
                                  items: state.volumes.map((volume) {
                                    return DropdownMenuItem<String>(
                                      value: volume.id,
                                      child: Text(volume.title),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedVolumeId = newValue;
                                      selectedIssueId = null;
                                    });
                                    if (newValue != null) {
                                      context.read<IssueBloc>().add(
                                          GetIssueByVolumeIdEvent(newValue));
                                    }
                                  },
                                );
                              }
                              return SizedBox.shrink();
                            },
                          ),
                          SizedBox(height: 16),
                          BlocBuilder<IssueBloc, IssueState>(
                            builder: (context, state) {
                              if (state is LoadedIssueByVolumeIdState) {
                                return DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Select Issue',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedIssueId,
                                  items: state.issues.map((issue) {
                                    return DropdownMenuItem<String>(
                                      value: issue.id,
                                      child: Text(issue.title),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIssueId = newValue;
                                    });
                                  },
                                );
                              }
                              return SizedBox.shrink();
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: title,
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
                            onChanged: (v) => title = v,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: documentType,
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
                            onChanged: (v) => documentType = v,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: abstractString,
                            decoration: InputDecoration(
                              labelText: 'Abstract',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an abstract';
                              }
                              return null;
                            },
                            onChanged: (v) => abstractString = v,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: mainSubjects.join(', '),
                            decoration: InputDecoration(
                              labelText: 'Main Subjects (comma-separated)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter at least one main subject';
                              }
                              return null;
                            },
                            onChanged: (v) => mainSubjects =
                                v.split(',').map((e) => e.trim()).toList(),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: keywords.join(', '),
                            decoration: InputDecoration(
                              labelText: 'Keywords (comma-separated)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter at least one keyword';
                              }
                              return null;
                            },
                            onChanged: (v) => keywords =
                                v.split(',').map((e) => e.trim()).toList(),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: references.join('\n'),
                            decoration: InputDecoration(
                              labelText: 'References (one per line)',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter at least one reference';
                              }
                              return null;
                            },
                            onChanged: (v) => references =
                                v.split('\n').map((e) => e.trim()).toList(),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: pdf,
                            decoration: InputDecoration(
                              labelText: 'PDF URL',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a PDF URL';
                              }
                              return null;
                            },
                            onChanged: (v) => pdf = v,
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: image.isNotEmpty
                                    ? Image.network(image, height: 100)
                                    : Text('No image uploaded'),
                              ),
                              SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () async {
                                  // Implement image upload logic
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                child: Text('Change Image'),
                              ),
                            ],
                          ),
                          SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  selectedJournalId != null &&
                                  selectedVolumeId != null &&
                                  selectedIssueId != null) {
                                final updatedArticle = article.copyWith(
                                  journalId: selectedJournalId,
                                  volumeId: selectedVolumeId,
                                  issueId: selectedIssueId,
                                  title: title,
                                  documentType: documentType,
                                  abstractString: abstractString,
                                  mainSubjects: mainSubjects,
                                  keywords: keywords,
                                  references: references,
                                  pdf: pdf,
                                  image: image,
                                  updatedAt: DateTime.now(),
                                );
                                context.read<ArticleBloc>().add(
                                    EditArticleEvent(article: updatedArticle));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Article updated successfully!'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                                Get.offNamed(Routes.dashboard,
                                    parameters: {'i': 'a'});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Please fill all required fields'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            child: Text('Update Article'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Failed to load article'));
          }
        },
      ),
    );
  }
}
