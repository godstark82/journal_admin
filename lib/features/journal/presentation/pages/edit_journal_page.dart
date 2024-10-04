import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditJournalPage extends StatefulWidget {
  const EditJournalPage({super.key});

  @override
  _EditJournalPageState createState() => _EditJournalPageState();
}

class _EditJournalPageState extends State<EditJournalPage> {
  final journalId = Get.parameters['journalId']!;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _domainController;

  @override
  void initState() {
    log(journalId);
    super.initState();
    _titleController = TextEditingController();
    _domainController = TextEditingController();
    context.read<JournalBloc>().add(GetJournalByIdEvent(id: journalId));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  void _submitForm(JournalModel journal) {
    if (_formKey.currentState!.validate()) {
      final updatedJournal = journal.copyWith(
        title: _titleController.text,
        domain: _domainController.text,
      );
      context
          .read<JournalBloc>()
          .add(UpdateJournalEvent(journal: updatedJournal));
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Journal'),
      ),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          if (state is JournalByIdLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JournalByIdLoaded) {
            final journal = state.journal;
            _titleController.text = journal.title;
            _domainController.text = journal.domain;
            return ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) {
                  return _buildDesktopView(journal);
                } else {
                  return _buildMobileView(journal);
                }
              },
            );
          } else if (state is JournalError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  Widget _buildDesktopView(JournalModel journal) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: _buildForm(journal),
      ),
    );
  }

  Widget _buildMobileView(JournalModel journal) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _buildForm(journal),
    );
  }

  Widget _buildForm(JournalModel journal) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _titleController,
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
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _domainController,
            decoration: const InputDecoration(
              labelText: 'Domain',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a domain';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _submitForm(journal),
            child: const Text('Update Journal'),
          ),
        ],
      ),
    );
  }
}
