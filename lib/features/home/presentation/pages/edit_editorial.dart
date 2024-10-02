import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/models/editorial_board_model.dart';
import 'package:journal_web/services/admin_services.dart';

class EditEditorialPage extends StatefulWidget {
  const EditEditorialPage({super.key});

  @override
  _EditEditorialPageState createState() => _EditEditorialPageState();
}

class _EditEditorialPageState extends State<EditEditorialPage> {
  final memberId = Get.parameters['memberId']!;
  final _formKey = GlobalKey<FormState>();
  final AdminServices _adminServices = AdminServices();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Editorial Board Member'),
      ),
      body: FutureBuilder<EditorialBoardModel>(
        future: _adminServices.getEditorialBoardMember(memberId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          EditorialBoardModel member = snapshot.data!;
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        width:
                            constraints.maxWidth > 600 ? 600 : double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              initialValue: member.name,
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
                              onChanged: (value) =>
                                  member = member.copyWith(name: value),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              initialValue: member.email,
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
                              onChanged: (value) =>
                                  member = member.copyWith(email: value),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              initialValue: member.category,
                              decoration: InputDecoration(
                                labelText: 'Category',
                                filled: true,
                                fillColor: Colors.purple[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) =>
                                  member = member.copyWith(category: value),
                            ),
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
                                  _adminServices.updateEditorialBoardMember(
                                      member.id, member);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Editorial board member updated successfully')),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Update'),
                            ),
                          ],
                        ),
                      );
                    },
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
