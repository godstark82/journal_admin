import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:journal_web/features/issue/data/models/issue_model.dart';
import 'package:journal_web/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume_bloc.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';

class AddIssuePage extends StatefulWidget {
  const AddIssuePage({Key? key}) : super(key: key);

  @override
  _AddIssuePageState createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _issueNumberController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isActive = true;
  String? _selectedVolumeId;
  String? _selectedJournalId;

  @override
  void initState() {
    super.initState();
    context.read<VolumeBloc>().add(GetAllVolumesEvent());
    context.read<JournalBloc>().add(GetAllJournalEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _issueNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _fromDate != null &&
        _toDate != null &&
        _selectedVolumeId != null &&
        _selectedJournalId != null) {
      final newIssue = IssueModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        volumeId: _selectedVolumeId!,
        issueNumber: _issueNumberController.text,
        journalId: _selectedJournalId!,
        description: _descriptionController.text,
        fromDate: _fromDate!,
        toDate: _toDate!,
        isActive: _isActive,
      );
      context.read<IssueBloc>().add(AddIssueEvent(newIssue));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Issue'),
        backgroundColor: Colors.teal,
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.book, size: 80, color: Colors.teal),
          const SizedBox(height: 24),
          _buildTextField(_titleController, 'Issue Title', Icons.title),
          const SizedBox(height: 16),
          _buildVolumeDropdown(),
          const SizedBox(height: 16),
          _buildJournalDropdown(),
          const SizedBox(height: 16),
          _buildTextField(_issueNumberController, 'Issue Number',
              Icons.format_list_numbered),
          const SizedBox(height: 16),
          _buildTextField(
              _descriptionController, 'Description', Icons.description,
              maxLines: 3),
          const SizedBox(height: 16),
          _buildDatePicker('From Date', _fromDate,
              (date) => setState(() => _fromDate = date)),
          const SizedBox(height: 16),
          _buildDatePicker(
              'To Date', _toDate, (date) => setState(() => _toDate = date)),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Is Active'),
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
            activeColor: Colors.teal,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _submitForm,
            icon: const Icon(Icons.add),
            label: const Text('Add Issue'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildVolumeDropdown() {
    return BlocBuilder<VolumeBloc, VolumeState>(
      builder: (context, state) {
        if (state is VolumeLoadedAll) {
          return DropdownButtonFormField<String>(
            value: _selectedVolumeId,
            decoration: InputDecoration(
              labelText: 'Volume',
              prefixIcon: const Icon(Icons.volume_up, color: Colors.teal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: state.volumes.map((volume) {
              return DropdownMenuItem<String>(
                value: volume.id,
                child: Text(volume.title),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedVolumeId = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a volume';
              }
              return null;
            },
          );
        } else if (state is VolumeLoadingAll) {
          return const CircularProgressIndicator();
        } else {
          return const Text('Failed to load volumes');
        }
      },
    );
  }

  Widget _buildJournalDropdown() {
    return BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) {
        if (state is JournalsLoaded) {
          return DropdownButtonFormField<String>(
            value: _selectedJournalId,
            decoration: InputDecoration(
              labelText: 'Journal',
              prefixIcon: const Icon(Icons.library_books, color: Colors.teal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: state.journals.map((journal) {
              return DropdownMenuItem<String>(
                value: journal.id,
                child: Text(journal.title),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedJournalId = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a journal';
              }
              return null;
            },
          );
        } else if (state is JournalsLoading) {
          return const CircularProgressIndicator();
        } else {
          return const Text('Failed to load journals');
        }
      },
    );
  }

  Widget _buildDatePicker(
      String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.teal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          selectedDate != null
              ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
              : 'Select a date',
        ),
      ),
    );
  }
}
