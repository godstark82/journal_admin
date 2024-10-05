import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/common/widgets/snack_bars.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:journal_web/features/login/data/models/editor_model.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:ui';
import 'package:journal_web/routes.dart';

class EditorSignup extends StatefulWidget {
  const EditorSignup({super.key});

  @override
  _EditorSignupState createState() => _EditorSignupState();
}

class _EditorSignupState extends State<EditorSignup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  EditorModel tempEditor = EditorModel();
  bool _obscureText = true;

  final List<String> titleOptions = ['Dr.', 'Prof.', 'Mr.', 'Ms.', 'Mrs.'];

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
                                'Register as Editor',
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
            Expanded(child: _buildDropdownField('Title', titleOptions, (v) => tempEditor.title = v)),
            SizedBox(width: 16),
            Expanded(flex: 2, child: _buildTextField('Full Name', (v) => tempEditor.name = v)),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(flex: 2, child: _buildTextField('Email', (v) => tempEditor.email = v)),
            SizedBox(width: 16),
            Expanded(child: _buildPasswordField()),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Mobile', (v) => tempEditor.mobile = v)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('Country', (v) => tempEditor.country = v)),
          ],
        ),
        SizedBox(height: 16),
        _buildTextField('Address', (v) => tempEditor.correspondingAddress = v),
        SizedBox(height: 16),
        _buildTextField('Details CV', (v) => tempEditor.detailsCV = v),
        SizedBox(height: 16),
        _buildTextField('Research Domains', (v) => tempEditor.researchDomain = v),
      ],
    );
  }

  Widget _buildMobileFields() {
    return Column(
      children: [
        _buildDropdownField('Title', titleOptions, (v) => tempEditor.title = v),
        SizedBox(height: 16),
        _buildTextField('Full Name', (v) => tempEditor.name = v),
        SizedBox(height: 16),
        _buildTextField('Email', (v) => tempEditor.email = v),
        SizedBox(height: 16),
        _buildPasswordField(),
        SizedBox(height: 16),
        _buildTextField('Mobile', (v) => tempEditor.mobile = v),
        SizedBox(height: 16),
        _buildTextField('Country', (v) => tempEditor.country = v),
        SizedBox(height: 16),
        _buildTextField('Address', (v) => tempEditor.correspondingAddress = v),
        SizedBox(height: 16),
        _buildTextField('Details CV', (v) => tempEditor.detailsCV = v),
        SizedBox(height: 16),
        _buildTextField('Research Domains', (v) => tempEditor.researchDomain = v),
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
      onChanged: (v) => tempEditor.password = v,
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

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      if (tempEditor.title == null || tempEditor.title!.isEmpty) {
        MySnacks.showErrorSnack('Title cannot be empty');
      } else {
        context.read<LoginBloc>().add(
          LoginEditorSignupEvent(editor: tempEditor) 
        );
      }
    }
  }
}
