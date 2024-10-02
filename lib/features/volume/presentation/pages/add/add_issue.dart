import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/volume/presentation/bloc/issue/issue_bloc.dart';
import 'package:journal_web/features/volume/data/models/issue_model.dart';



class AddIssuePage extends StatefulWidget {
  final String? volumeId;
  const AddIssuePage({super.key, this.volumeId});

  @override
  _AddIssuePageState createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  late final String? volumeId;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _issueNumberController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    volumeId = widget.volumeId ?? Get.parameters['volumeId'];
    if (volumeId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Volume ID is missing. Please try again.')),
        );
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Issue'),
      ),
      body: BlocListener<IssueBloc, IssueState>(
        listener: (context, state) {
          if (state is IssueAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Issue added successfully')),
            );
            Navigator.of(context).pop();
          } else if (state is IssuesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '* Articles will be added later',
                  style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _issueNumberController,
                  decoration: InputDecoration(labelText: 'Issue Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an issue number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _fromDateController,
                  decoration: InputDecoration(
                    labelText: 'From Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      _fromDateController.text =
                          pickedDate.toIso8601String().split('T')[0];
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a from date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _toDateController,
                  decoration: InputDecoration(
                    labelText: 'To Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      _toDateController.text =
                          pickedDate.toIso8601String().split('T')[0];
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a to date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isActive,
                      onChanged: (bool? value) {
                        setState(() {
                          _isActive = value ?? false;
                        });
                      },
                    ),
                    Text('Is Active'),
                  ],
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Add Issue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && volumeId != null) {
      final newIssue = IssueModel(
        volumeId: volumeId!,
        title: _titleController.text,
        issueNumber: _issueNumberController.text,
        description: _descriptionController.text,
        fromDate: DateTime.tryParse(_fromDateController.text),
        toDate: DateTime.tryParse(_toDateController.text),
        isActive: _isActive,
      );

      context
          .read<IssueBloc>()
          .add(AddIssueEvent(issue: newIssue, volumeId: volumeId!));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adding issue...')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _issueNumberController.dispose();
    _descriptionController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }
}
