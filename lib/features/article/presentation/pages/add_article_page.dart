import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/core/const/roles.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:journal_web/features/users/presentation/bloc/users_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume_bloc.dart';
import 'package:journal_web/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String documentType = '';
  String abstractString = '';
  List<String> mainSubjects = [];
  List<String> keywords = [];
  List<String> references = [];
  String pdf = '';
  String image = '';
  bool _isUploading = false;
  bool _isPdfUploading = false;
  String? selectedJournalId;
  String? selectedVolumeId;
  String? selectedIssueId;
  List<MyUser> selectedAuthors = [];

  @override
  void initState() {
    super.initState();
    context.read<JournalBloc>().add(GetAllJournalEvent());
    context.read<UsersBloc>().add(GetUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Article'),
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
                    BlocBuilder<JournalBloc, JournalState>(
                      builder: (context, state) {
                        if (state is JournalsLoaded) {
                          var journals = state.journals;
                          if (LoginConst.currentUser?.role != Role.admin) {
                            journals = journals.where((journal) => 
                              LoginConst.currentUser?.journalIds?.contains(journal.id) ?? false
                            ).toList();
                          }
                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Select Journal',
                              border: OutlineInputBorder(),
                            ),
                            value: selectedJournalId,
                            items: journals.map((journal) {
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
                        return SizedBox(
                            height: 20,
                            width: 20,
                            child: const CircularProgressIndicator());
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<VolumeBloc, VolumeState>(
                      builder: (context, state) {
                        if (state is VolumeLoadedByJournalId) {
                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
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
                                context
                                    .read<IssueBloc>()
                                    .add(GetIssueByVolumeIdEvent(newValue));
                              }
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<IssueBloc, IssueState>(
                      builder: (context, state) {
                        if (state is LoadedIssueByVolumeIdState) {
                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
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
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<UsersBloc, UsersState>(
                      builder: (context, state) {
                        if (state is UsersLoaded) {
                          return MultiSelectDialogField<MyUser>(
                            items: state.users!
                                .where((user) => user.role == Role.author)
                                .map((author) => MultiSelectItem<MyUser>(
                                    author,
                                    '${author.name ?? ''}\n'
                                    'Email: ${author.email}\n'
                                    'Designation: ${author.designation ?? 'N/A'}'))
                                .toList(),
                            title: const Text("Select Authors"),
                            selectedColor: Theme.of(context).primaryColor,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40)),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            buttonIcon: Icon(
                              Icons.people,
                              color: Theme.of(context).primaryColor,
                            ),
                            buttonText: Text(
                              "Select Authors",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                              ),
                            ),
                            onConfirm: (results) {
                              setState(() {
                                selectedAuthors = results;
                              });
                            },
                            chipDisplay: MultiSelectChipDisplay(
                              onTap: (value) {
                                setState(() {
                                  selectedAuthors.remove(value);
                                });
                              },
                              chipColor: Colors.blue.withOpacity(0.1),
                              textStyle: const TextStyle(color: Colors.blue),
                            ),
                            itemsTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          );
                        }
                        return const SizedBox(
                            height: 50,
                            width: 50,
                            child:  CircularProgressIndicator());
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
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
                      onChanged: (v) => title = v,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 16),
                    TextFormField(
                      onChanged: (v) => abstractString = v,
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Main Subjects (comma-separated)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter main subjects';
                        }
                        return null;
                      },
                      onChanged: (v) => mainSubjects =
                          v.split(',').map((e) => e.trim()).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onChanged: (v) =>
                          keywords = v.split(',').map((e) => e.trim()).toList(),
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 16),
                    TextFormField(
                      onChanged: (v) => references =
                          v.split(',').map((e) => e.trim()).toList(),
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf'],
                                allowMultiple: false,
                              );

                              if (result != null) {
                                setState(() {
                                  _isPdfUploading = true;
                                });

                                PlatformFile file = result.files.first;
                                String journalName = 'DefaultJournal';
                                String volumeName = 'DefaultVolume';
                                String issueName = 'DefaultIssue';
                                String authorsName = 'DefaultAuthor';

                                // Get journal, volume, issue names if selected
                                if (selectedJournalId != null) {
                                  final journal = (context
                                          .read<JournalBloc>()
                                          .state as JournalsLoaded)
                                      .journals
                                      .firstWhere(
                                          (j) => j.id == selectedJournalId);
                                  journalName =
                                      journal.title.replaceAll(' ', '_');
                                }
                                if (selectedVolumeId != null) {
                                  final volume = (context
                                          .read<VolumeBloc>()
                                          .state as VolumeLoadedByJournalId)
                                      .volumes
                                      .firstWhere(
                                          (v) => v.id == selectedVolumeId);
                                  volumeName =
                                      volume.title.replaceAll(' ', '_');
                                }
                                if (selectedIssueId != null) {
                                  final issue = (context.read<IssueBloc>().state
                                          as LoadedIssueByVolumeIdState)
                                      .issues
                                      .firstWhere(
                                          (i) => i.id == selectedIssueId);
                                  issueName = issue.title.replaceAll(' ', '_');
                                }
                                if (selectedAuthors.isNotEmpty) {
                                  authorsName = selectedAuthors
                                      .map((a) => a.name)
                                      .join('_');
                                }

                                String uniqueId = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                String fileName =
                                    '${journalName}_${volumeName}_${issueName}_${authorsName}_$uniqueId.pdf';

                                try {
                                  // Upload to Firebase Storage
                                  Reference ref = FirebaseStorage.instance
                                      .ref()
                                      .child('article_pdfs/$fileName');
                                  UploadTask uploadTask =
                                      ref.putData(file.bytes!);

                                  // Listen to upload progress
                                  uploadTask.snapshotEvents
                                      .listen((TaskSnapshot snapshot) {
                                    double progress =
                                        snapshot.bytesTransferred /
                                            snapshot.totalBytes;
                                    print(
                                        'Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
                                  });

                                  TaskSnapshot snapshot = await uploadTask;
                                  String downloadUrl =
                                      await snapshot.ref.getDownloadURL();

                                  // Save the download URL to the article
                                  setState(() {
                                    pdf = downloadUrl;
                                    _isPdfUploading = false;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('PDF uploaded successfully')),
                                  );
                                } catch (e) {
                                  print('Error uploading PDF: $e');
                                  setState(() {
                                    _isPdfUploading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Failed to upload PDF')),
                                  );
                                }
                              }
                            },
                            icon: _isPdfUploading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.upload_file, size: 18),
                            label: Text(_isPdfUploading
                                ? 'Uploading...'
                                : 'Upload PDF'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              minimumSize: const Size(120, 36),
                            ),
                          ),
                          if (pdf.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'PDF uploaded',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () async {
                                if (await canLaunchUrl(Uri.parse(pdf))) {
                                  await launchUrl(Uri.parse(pdf));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Could not open PDF')),
                                  );
                                }
                              },
                              child: const Text('View PDF'),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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
                                    image = downloadUrl;
                                    _isUploading = false;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Image uploaded successfully')),
                                  );
                                } catch (e) {
                                  print('Error uploading image: $e');
                                  setState(() {
                                    _isUploading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Failed to upload image')),
                                  );
                                }
                              }
                            },
                            icon: _isUploading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.image, size: 18),
                            label: Text(
                                _isUploading ? 'Uploading...' : 'Upload Image'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              minimumSize: const Size(120, 36),
                            ),
                          ),
                          if (image.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Image uploaded',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Image.network(
                              image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            selectedJournalId != null &&
                            selectedVolumeId != null &&
                            selectedIssueId != null &&
                            selectedAuthors.isNotEmpty &&
                            pdf.isNotEmpty) {
                          final article = ArticleModel(
                            id: '',
                            authors: selectedAuthors,
                            journalId: selectedJournalId!,
                            volumeId: selectedVolumeId!,
                            issueId: selectedIssueId!,
                            comments: [],
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            status: ArticleStatus.pending.value,
                            title: title,
                            documentType: documentType,
                            abstractString: abstractString,
                            mainSubjects: mainSubjects,
                            keywords: keywords,
                            references: references,
                            pdf: pdf,
                            image: image,
                          );
                          context
                              .read<ArticleBloc>()
                              .add(AddArticleEvent(article: article));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Article published successfully!'),
                              duration: Duration(seconds: 3),
                            ),
                          );

                          // Use Get.back() with a result
                          Get.back(result: true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please fill all required fields and upload a PDF'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      child: const Text('Submit Article'),
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
