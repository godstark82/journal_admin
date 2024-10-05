import 'package:flutter/material.dart';
import 'package:journal_web/core/models/editorial_board_model.dart';
import 'package:journal_web/services/admin_services.dart';

class AddEditorialPage extends StatefulWidget {
  const AddEditorialPage({super.key});

  @override
  _AddEditorialPageState createState() => _AddEditorialPageState();
}

class _AddEditorialPageState extends State<AddEditorialPage> {
  final _formKey = GlobalKey<FormState>();
  final AdminServices _adminServices = AdminServices();

  String name = '';
  String email = '';
  EditorialBoardRole? selectedRole;
  String institution = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Editorial Board Member'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth > 600 ? 600 : double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            filled: true,
                            fillColor: Colors.blue[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                          onSaved: (value) => name = value!,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.green[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            return null;
                          },
                          onSaved: (value) => email = value!,
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<EditorialBoardRole>(
                          decoration: InputDecoration(
                            labelText: 'Role',
                            filled: true,
                            fillColor: Colors.purple[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: selectedRole,
                          items: EditorialBoardRole.values.map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Text(role.value),
                            );
                          }).toList(),
                          onChanged: (EditorialBoardRole? newValue) {
                            setState(() {
                              selectedRole = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a role';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Institution',
                            filled: true,
                            fillColor: Colors.purple[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an institution';
                            }
                            return null;
                          },
                          onSaved: (value) => institution = value!,
                        ),
                        SizedBox(height: 20),
                        SizedBox(height: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            textStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              final member = EditorialBoardModel(
                                id: '1',
                                name: name,
                                email: email,
                                role: selectedRole!.value,
                                institution: institution,
                                createdAt: DateTime.now(),
                              );
                              _adminServices.addEditorialBoardMember(member);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Editorial board member added successfully')),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
