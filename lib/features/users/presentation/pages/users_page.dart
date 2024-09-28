import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_web/features/login/data/models/admin_model.dart';
import 'package:journal_web/features/login/data/models/author_model.dart';
import 'package:journal_web/features/login/data/models/editor_model.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:journal_web/features/users/presentation/bloc/users_bloc.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersInitial) {
          context.read<UsersBloc>().add(GetUsersEvent());
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersLoaded) {
          final authors = state.users
                  ?.where((user) => user.role?.toLowerCase() == 'author')
                  .toList() ??
              [];
          final editors = state.users
                  ?.where((user) => user.role?.toLowerCase() == 'editor')
                  .toList() ??
              [];
          final reviewers = state.users
                  ?.where((user) => user.role?.toLowerCase() == 'reviewer')
                  .toList() ??
              [];
          final others = state.users
                  ?.where((user) => !['author', 'editor', 'reviewer']
                      .contains(user.role?.toLowerCase()))
                  .toList() ??
              [];

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Users'),
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // Desktop layout
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          if (authors.isNotEmpty)
                            SizedBox(
                                width: constraints.maxWidth / 2 - 24,
                                child: _buildUserSection('Authors', authors)),
                          if (editors.isNotEmpty)
                            SizedBox(
                                width: constraints.maxWidth / 2 - 24,
                                child: _buildUserSection('Editors', editors)),
                          if (reviewers.isNotEmpty)
                            SizedBox(
                                width: constraints.maxWidth / 2 - 24,
                                child:
                                    _buildUserSection('Reviewers', reviewers)),
                          if (others.isNotEmpty)
                            SizedBox(
                                width: constraints.maxWidth / 2 - 24,
                                child: _buildUserSection('Others', others)),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Mobile layout
                  return ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      if (authors.isNotEmpty)
                        _buildUserSection('Authors', authors),
                      if (editors.isNotEmpty)
                        _buildUserSection('Editors', editors),
                      if (reviewers.isNotEmpty)
                        _buildUserSection('Reviewers', reviewers),
                      if (others.isNotEmpty)
                        _buildUserSection('Others', others),
                    ],
                  );
                }
              },
            ),
          );
        } else if (state is UsersLoadedSpecific) {
          final user = state.user;
          Widget userDetails;

          if (user?.role?.toLowerCase() == 'author') {
            final authorModel = state.user as AuthorModel;
            userDetails = buildAuthorDetails(authorModel);
          } else if (user?.role?.toLowerCase() == 'editor') {
            final editorModel = state.user as EditorModel;
            userDetails = buildEditorDetails(editorModel);
          } else if (user?.role?.toLowerCase() == 'reviewer') {
            final reviewerModel = state.user as ReviewerModel;
            userDetails = buildReviewerDetails(reviewerModel);
          } else {
            final genericUser = state.user as AdminModel;
            userDetails = buildGenericUserDetails(genericUser);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('${user?.role ?? 'User'} Details'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.read<UsersBloc>().add(GetUsersEvent()),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: _getUserColor(user?.role),
                            child: Text(
                              user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                              style:
                                  TextStyle(fontSize: 32, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        userDetails,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('Something went wrong'));
        }
      },
    );
  }

  Widget _buildUserSection(String title, List<dynamic> users) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: users.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getUserColor(user.role),
                  child: _getUserIcon(user.role),
                ),
                title: Text(user.name ?? 'N/A',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.email ?? 'N/A'),
                    Text('Role: ${user.role ?? 'N/A'}',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  ],
                ),
                onTap: () {
                  context
                      .read<UsersBloc>()
                      .add(GetSpecificUserEvent(userId: user.id!));
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getUserColor(String? role) {
    switch (role?.toLowerCase()) {
      case 'editor':
        return Colors.blue;
      case 'reviewer':
        return Colors.green;
      case 'author':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Icon _getUserIcon(String? role) {
    switch (role?.toLowerCase()) {
      case 'editor':
        return Icon(Icons.edit, color: Colors.white);
      case 'reviewer':
        return Icon(Icons.rate_review, color: Colors.white);
      case 'author':
        return Icon(Icons.create, color: Colors.white);
      default:
        return Icon(Icons.person, color: Colors.white);
    }
  }
}

Widget buildAuthorDetails(AuthorModel? author) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isDesktop = constraints.maxWidth > 600;
      return Card(
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            children: [
              _buildDetailItem(
                  Icons.person,
                  'Name',
                  author?.name,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.email,
                  'Email',
                  author?.email,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.title,
                  'Title',
                  author?.title,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.home,
                  'Address',
                  author?.address,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.location_city,
                  'City',
                  author?.city,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.flag,
                  'Country',
                  author?.country,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.fingerprint,
                  'ORCID',
                  author?.orcId,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.work,
                  'Designation',
                  author?.designation,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.psychology,
                  'Specialization',
                  author?.specialization,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.school,
                  'Field of Study',
                  author?.fieldOfStudy,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.phone,
                  'Mobile',
                  author?.mobile,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.map,
                  'State',
                  author?.state,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.pin_drop,
                  'Pin Code',
                  author?.pinCode,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildEditorDetails(EditorModel? editor) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isDesktop = constraints.maxWidth > 600;
      return Card(
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            children: [
              _buildDetailItem(
                  Icons.person,
                  'Name',
                  editor?.name,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.email,
                  'Email',
                  editor?.email,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.title,
                  'Title',
                  editor?.title,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.home,
                  'Corresponding Address',
                  editor?.correspondingAddress,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.flag,
                  'Country',
                  editor?.country,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.book,
                  'Journal Name',
                  editor?.journalName,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.phone,
                  'Mobile',
                  editor?.mobile,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.science,
                  'Research Domain',
                  editor?.researchDomain,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildReviewerDetails(ReviewerModel? reviewer) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isDesktop = constraints.maxWidth > 600;
      return Card(
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            children: [
              _buildDetailItem(
                  Icons.person,
                  'Name',
                  reviewer?.name,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.email,
                  'Email',
                  reviewer?.email,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.title,
                  'Title',
                  reviewer?.title,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.home,
                  'Corresponding Address',
                  reviewer?.correspondingAddress,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.flag,
                  'Country',
                  reviewer?.country,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.book,
                  'Journal',
                  reviewer?.journal,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.phone,
                  'Mobile',
                  reviewer?.mobile,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.science,
                  'Research Domain',
                  reviewer?.researchDomain,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildGenericUserDetails(AdminModel user) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isDesktop = constraints.maxWidth > 600;
      return Card(
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            children: [
              _buildDetailItem(
                  Icons.person,
                  'Name',
                  user.name,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.email,
                  'Email',
                  user.email,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.work,
                  'Role',
                  user.role,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildDetailItem(
    IconData icon, String label, String? value, double width, bool isDesktop) {
  return Container(
    width: width,
    child: Row(
      mainAxisAlignment:
          isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        SizedBox(width: 10),
        Flexible(
          child: RichText(
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                    text: '$label: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value ?? 'N/A'),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
