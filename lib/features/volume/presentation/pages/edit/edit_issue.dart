import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:journal_web/features/volume/data/models/issue_model.dart';
import 'package:journal_web/features/volume/presentation/bloc/issue/issue_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/issue/singleissue/singleissue_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditIssuePage extends StatefulWidget {
  const EditIssuePage({super.key});

  @override
  _EditIssuePageState createState() => _EditIssuePageState();
}

class _EditIssuePageState extends State<EditIssuePage> {
  final _formKey = GlobalKey<FormState>();
  IssueModel issueModel = IssueModel();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _issueNumberController;
  late DateTime _fromDate;
  late DateTime _toDate;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _issueNumberController = TextEditingController();
    _fromDate = DateTime.now();
    _toDate = DateTime.now().add(Duration(days: 90));
    _loadIssueData();
  }

  void _loadIssueData() {
    final issueId = Get.parameters['issueId'];
    final volumeId = Get.parameters['volumeId'];
    if (issueId != null && volumeId != null) {
      context
          .read<SingleissueBloc>()
          .add(LoadSingleIssueEvent(issueId: issueId, volumeId: volumeId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Issue'),
        backgroundColor: Colors.teal,
      ),
      body: BlocBuilder<SingleissueBloc, SingleissueState>(
        builder: (context, state) {
          if (state is SingleIssueLoaded) {
            final issue = state.issue;
            issueModel = issue;
            _titleController.text = issue.title ?? '';
            _descriptionController.text = issue.description ?? '';
            _issueNumberController.text = issue.issueNumber?.toString() ?? '';
            _fromDate = issue.fromDate ?? DateTime.now();
            _toDate = issue.toDate ?? DateTime.now().add(Duration(days: 7));
            _isActive = issue.isActive ?? true;

            return ResponsiveBuilder(
              builder: (context, sizingInformation) {
                return Center(
                  child: Container(
                    width: sizingInformation.deviceScreenType ==
                            DeviceScreenType.desktop
                        ? 600
                        : double.infinity,
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              controller: _titleController,
                              label: 'Title',
                              icon: Icons.title,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 16),
                            _buildTextField(
                              controller: _descriptionController,
                              label: 'Description',
                              icon: Icons.description,
                              color: Colors.green,
                              maxLines: 3,
                            ),
                            SizedBox(height: 16),
                            _buildTextField(
                              controller: _issueNumberController,
                              label: 'Issue Number',
                              icon: Icons.format_list_numbered,
                              color: Colors.amber,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 16),
                            _buildDatePicker(
                              label: 'From Date',
                              date: _fromDate,
                              onDateChanged: (date) =>
                                  setState(() => _fromDate = date),
                              color: Colors.purple,
                            ),
                            SizedBox(height: 16),
                            _buildDatePicker(
                              label: 'To Date',
                              date: _toDate,
                              onDateChanged: (date) =>
                                  setState(() => _toDate = date),
                              color: Colors.orange,
                            ),
                            SizedBox(height: 16),
                            _buildSwitchField(
                              label: 'Is Active',
                              value: _isActive,
                              onChanged: (value) =>
                                  setState(() => _isActive = value),
                              color: Colors.indigo,
                            ),
                            SizedBox(height: 24),
                            Center(
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.save),
                                label: Text('Save Changes'),
                                onPressed: _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime date,
    required Function(DateTime) onDateChanged,
    required Color color,
  }) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != date) {
          onDateChanged(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.calendar_today, color: color),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('dd-MM-yyyy').format(date)),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchField({
    required String label,
    required bool value,
    required Function(bool) onChanged,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: color,
        ),
      ],
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      issueModel.title = _titleController.text;
      issueModel.description = _descriptionController.text;
      issueModel.issueNumber = _issueNumberController.text;
      issueModel.fromDate = _fromDate;
      issueModel.toDate = _toDate;
      issueModel.isActive = _isActive;

      final issueId = Get.parameters['issueId'];
      final volumeId = Get.parameters['volumeId'];

      if (issueId != null && volumeId != null) {
        context.read<IssueBloc>().add(UpdateIssueEvent(issue: issueModel));
        Get.back(result: true);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _issueNumberController.dispose();
    super.dispose();
  }
}
