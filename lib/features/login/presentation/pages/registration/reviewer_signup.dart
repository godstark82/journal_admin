import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/common/widgets/snack_bars.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:ui';
import 'package:journal_web/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ReviewerSignup extends StatefulWidget {
  const ReviewerSignup({super.key});

  @override
  _ReviewerSignupState createState() => _ReviewerSignupState();
}

class _ReviewerSignupState extends State<ReviewerSignup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ReviewerModel tempReviewer = ReviewerModel();
  bool _obscureText = true;
  String? _cvFileName;
  List<String> selectedJournalIds = [];

  final List<String> titleOptions = ['Dr.', 'Prof.', 'Mr.', 'Ms.', 'Mrs.'];

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
                    width: sizingInfo.isDesktop ? 800 : (sizingInfo.isTablet ? 600 : context.width * 0.9),
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
                                'Register as Reviewer',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.toNamed(Routes.login),
                                child: Text('Sign In', style: TextStyle(color: Colors.blue[700])),
                              ),
                            ],
                          ),
                          SizedBox(height: 32),
                          if (sizingInfo.isDesktop) 
                            _buildDesktopFields()
                          else
                            _buildMobileFields(),
                          SizedBox(height: 32),
                          _buildCvUploadButton(),
                          SizedBox(height: 16),
                          _buildJournalSelection(),
                          SizedBox(height: 32),
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              if (state is LoginLoadingState) {
                                return Center(child: CircularProgressIndicator());
                              }
                              return Center(
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue[700],
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text('Submit', style: TextStyle(fontSize: 18)),
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
            Expanded(child: _buildDropdownField('Title', titleOptions, (v) => tempReviewer.title = v)),
            SizedBox(width: 16),
            Expanded(flex: 2, child: _buildTextField('Full Name', (v) => tempReviewer.name = v)),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(flex: 2, child: _buildTextField('Email', (v) => tempReviewer.email = v)),
            SizedBox(width: 16),
            Expanded(child: _buildPasswordField()),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Mobile', (v) => tempReviewer.mobile = v)),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Country', (v) => tempReviewer.country = v)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('Corresponding Address', (v) => tempReviewer.correspondingAddress = v)),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Research Domains', (v) => tempReviewer.researchDomain = v)),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFields() {
    return Column(
      children: [
        _buildDropdownField('Title', titleOptions, (v) => tempReviewer.title = v),
        SizedBox(height: 16),
        _buildTextField('Full Name', (v) => tempReviewer.name = v),
        SizedBox(height: 16),
        _buildTextField('Email', (v) => tempReviewer.email = v),
        SizedBox(height: 16),
        _buildPasswordField(),
        SizedBox(height: 16),
        _buildTextField('Mobile', (v) => tempReviewer.mobile = v),
        SizedBox(height: 16),
        _buildTextField('Country', (v) => tempReviewer.country = v),
        SizedBox(height: 16),
        _buildTextField('Corresponding Address', (v) => tempReviewer.correspondingAddress = v),
        SizedBox(height: 16),
        _buildTextField('Research Domains', (v) => tempReviewer.researchDomain = v),
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
      onChanged: (v) => tempReviewer.password = v,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, List<String> items, Function(String?) onChanged) {
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

  Widget _buildCvUploadButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        if (result != null) {
          setState(() {
            _cvFileName = result.files.single.name;
            tempReviewer.cvPdfUrl = result.files.single.path;
          });
        }
      },
      icon: Icon(Icons.upload_file),
      label: Text(_cvFileName ?? 'Upload CV (PDF)'),
    );
  }

  Widget _buildJournalSelection() {
    return BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) {
        if (state is JournalsLoaded) {
          List<MultiSelectItem<String>> items = state.journals
              .map((journal) => MultiSelectItem<String>(journal.id, '${journal.domain}.abhijournals.com : ${journal.title}'))
              .toList();

          return MultiSelectDialogField(
            items: items,
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
              tempReviewer.journalIds = selectedJournalIds;
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      if (tempReviewer.title == null || tempReviewer.title!.isEmpty) {
        MySnacks.showErrorSnack('Title cannot be empty');
      } else if (tempReviewer.country == null || tempReviewer.country!.isEmpty) {
        MySnacks.showErrorSnack('Country cannot be empty');
      } else if (tempReviewer.cvPdfUrl == null) {
        MySnacks.showErrorSnack('Please upload your CV');
      } else if (selectedJournalIds.isEmpty) {
        MySnacks.showErrorSnack('Please select at least one journal');
      } else {
        context.read<LoginBloc>().add(
          LoginReviewerSignupEvent(reviewer: tempReviewer) 
        );
      }
    }
  }
}
