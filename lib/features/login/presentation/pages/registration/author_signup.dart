import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/common/widgets/snack_bars.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:journal_web/features/login/data/models/author_model.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:ui';
import 'package:journal_web/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AuthorSignup extends StatefulWidget {
  const AuthorSignup({super.key});

  @override
  _AuthorSignupState createState() => _AuthorSignupState();
}

class _AuthorSignupState extends State<AuthorSignup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthorModel tempAuthor = AuthorModel();
  bool _obscureText = true;
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  final List<String> titleOptions = ['Dr.', 'Prof.', 'Mr.', 'Ms.', 'Mrs.'];
  final List<String> designationOptions = [
    'Professor',
    'Assistant Professor',
    'Associate Professor',
    'Instructor',
    'Other'
  ];

  List<JournalModel> availableJournals = [];
  List<String> selectedJournalIds = [];

  @override
  void initState() {
    super.initState();
    context.read<JournalBloc>().add(GetAllJournalEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[100]!, Colors.purple[100]!],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          Center(
            child: ResponsiveBuilder(
              builder: (context, sizingInfo) {
                return SingleChildScrollView(
                  child: Container(
                    width: sizingInfo.isDesktop
                        ? 800
                        : (sizingInfo.isTablet ? 600 : context.width * 0.9),
                    margin: EdgeInsets.symmetric(vertical: 32),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Register as Author',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.toNamed(Routes.login),
                                child: Text('Sign In',
                                    style: TextStyle(color: Colors.blue[700])),
                              ),
                            ],
                          ),
                          SizedBox(height: 32),
                          if (sizingInfo.isDesktop)
                            _buildDesktopFields()
                          else
                            _buildMobileFields(),
                          SizedBox(height: 16),
                          _buildCVUploadButton(),
                          SizedBox(height: 8),
                          if (_isUploading)
                            LinearProgressIndicator(value: _uploadProgress),
                          if (!_isUploading &&
                              tempAuthor.cvPdfUrl != null &&
                              tempAuthor.cvPdfUrl!.isNotEmpty)
                            Wrap(
                              children: [
                                SelectableText(
                                  'CV uploaded at : ${tempAuthor.cvPdfUrl}',
                                  style: TextStyle(color: Colors.green),
                                ),
                                SizedBox(width: 16),
                                TextButton(
                                    onPressed: () {
                                      launchUrl(
                                          Uri.parse(tempAuthor.cvPdfUrl!));
                                    },
                                    child: Text('View'))
                              ],
                            ),
                          SizedBox(height: 16),
                          _buildJournalSelector(),
                          SizedBox(height: 32),
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              if (state is LoginLoadingState) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return Center(
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue[700],
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text('Submit',
                                      style: TextStyle(fontSize: 18)),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _buildDropdownField(
                    'Title', titleOptions, (v) => tempAuthor.title = v)),
            SizedBox(width: 16),
            Expanded(
                flex: 2,
                child:
                    _buildTextField('Full Name', (v) => tempAuthor.name = v)),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                flex: 2,
                child: _buildTextField('Email', (v) => tempAuthor.email = v)),
            SizedBox(width: 16),
            Expanded(child: _buildPasswordField()),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildDropdownField('Designation', designationOptions,
                    (v) => tempAuthor.designation = v)),
            SizedBox(width: 16),
            Expanded(
                child: _buildTextField(
                    'Specialization', (v) => tempAuthor.specialization = v)),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildTextField('Specific Field of Study',
                    (v) => tempAuthor.fieldOfStudy = v)),
            SizedBox(width: 16),
            Expanded(
                child: _buildTextField('Mobile', (v) => tempAuthor.mobile = v)),
          ],
        ),
        SizedBox(height: 16),
        _buildTextField('Address', (v) => tempAuthor.address = v),
        SizedBox(height: 16),
        _buildTextField('ORCID', (v) => tempAuthor.orcId = v),
      ],
    );
  }

  Widget _buildMobileFields() {
    return Column(
      children: [
        _buildDropdownField('Title', titleOptions, (v) => tempAuthor.title = v),
        SizedBox(height: 16),
        _buildTextField('Full Name', (v) => tempAuthor.name = v),
        SizedBox(height: 16),
        _buildTextField('Email', (v) => tempAuthor.email = v),
        SizedBox(height: 16),
        _buildPasswordField(),
        SizedBox(height: 16),
        _buildDropdownField('Designation', designationOptions,
            (v) => tempAuthor.designation = v),
        SizedBox(height: 16),
        _buildTextField('Specialization', (v) => tempAuthor.specialization = v),
        SizedBox(height: 16),
        _buildTextField(
            'Specific Field of Study', (v) => tempAuthor.fieldOfStudy = v),
        SizedBox(height: 16),
        _buildTextField('Mobile', (v) => tempAuthor.mobile = v),
        SizedBox(height: 16),
        _buildTextField('Address', (v) => tempAuthor.address = v),
        SizedBox(height: 16),
        _buildTextField('ORCID', (v) => tempAuthor.orcId = v),
      ],
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      onChanged: (v) => tempAuthor.password = v,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(
      String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _buildJournalSelector() {
    return BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) {
        if (state is JournalsLoaded) {
          availableJournals = state.journals;
          return MultiSelectDialogField(
            items: availableJournals
                .map((e) => MultiSelectItem<String>(e.id, '${e.domain}.abhijournals.com : ${e.title}'))
                .toList(),
            title: Text("Select Journals"),
            selectedColor: Colors.blue,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(40)),
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
            ),

            buttonIcon: Icon(
              Icons.book,
              color: Colors.blue,
            ),
            buttonText: Text(
              "Select Journals",
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 16,
              ),
            ),
            onConfirm: (results) {
              selectedJournalIds = results.cast<String>();
              tempAuthor.journalIds = selectedJournalIds;
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildCVUploadButton() {
    return ElevatedButton.icon(
      onPressed: _uploadCV,
      icon: Icon(Icons.upload_file),
      label: Text('Upload CV'),
    );
  }

  Future<void> _uploadCV() async {
    if (tempAuthor.title == null ||
        tempAuthor.name == null ||
        tempAuthor.email == null) {
      MySnacks.showErrorSnack('Please submit the form first');
      return;
    }
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      String fileName =
          '${tempAuthor.title}${tempAuthor.name}${tempAuthor.email}_cv.pdf';

      try {
        setState(() {
          _isUploading = true;
          _uploadProgress = 0;
        });

        UploadTask task;
        if (kIsWeb) {
          // Web platform
          task = FirebaseStorage.instance
              .ref('cvs/$fileName')
              .putData(result.files.single.bytes!);
        } else {
          // Mobile platform
          File file = File(result.files.single.path!);
          task = FirebaseStorage.instance.ref('cvs/$fileName').putFile(file);
        }

        task.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        });

        await task;

        String downloadURL = await FirebaseStorage.instance
            .ref('cvs/$fileName')
            .getDownloadURL();
        tempAuthor.cvPdfUrl = downloadURL;

        setState(() {
          _isUploading = false;
        });

        MySnacks.showSuccessSnack('CV uploaded successfully');
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        MySnacks.showErrorSnack('Failed to upload CV: $e');
      }
    }
  }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      if (tempAuthor.title == null || tempAuthor.title!.isEmpty) {
        MySnacks.showErrorSnack('Title cannot be empty');
      } else if (tempAuthor.cvPdfUrl == null || tempAuthor.cvPdfUrl!.isEmpty) {
        MySnacks.showErrorSnack('Please upload your CV');
      } else if (tempAuthor.journalIds == null || tempAuthor.journalIds!.isEmpty) {
        MySnacks.showErrorSnack('Please select at least one journal');
      } else {
        context
            .read<LoginBloc>()
            .add(LoginAuthorSignupEvent(author: tempAuthor));
      }
    }
  }
}
