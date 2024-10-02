import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:journal_web/features/volume/data/models/issue_model.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume/singlevolume/singlevolume_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume/volume_bloc.dart';
import 'package:journal_web/routes.dart';

class ViewVolumePage extends StatefulWidget {
  const ViewVolumePage({super.key});

  @override
  State<ViewVolumePage> createState() => _ViewVolumePageState();
}

class _ViewVolumePageState extends State<ViewVolumePage> {
  final String volumeId = Get.parameters['volumeId']!;

  @override
  initState() {
    super.initState();
    context
        .read<SinglevolumeBloc>()
        .add(GetSingleVolumeEvent(volumeId: volumeId));
  }

  void _showDeleteConfirmation(BuildContext context, VolumeModel volume) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text('Delete Volume', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_forever, color: Colors.red, size: 48),
              SizedBox(height: 16),
              Text(
                'Are you sure you want to delete this volume?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'This action cannot be undone.',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          backgroundColor: Colors.yellow[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteVolume(volume);
              },
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _deleteVolume(VolumeModel volume) {
    context.read<VolumeBloc>().add(DeleteVolumeEvent(volumeId: volume.id!));
    Get.offNamed(Routes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SinglevolumeBloc, SinglevolumeState>(
      builder: (context, state) {
        if (state is SingleVolumeLoaded) {
          VolumeModel volume = state.volume;
          return Scaffold(
            appBar: AppBar(
              title: Text('Volume ${volume.volumeNumber}'),
              backgroundColor: Colors.indigo[700],
              actions: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteConfirmation(context, volume);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600
                    ? context.width * 0.2
                    : 16,
                vertical: 16,
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${volume.title}',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo[800])),
                          GFButton(
                            onPressed: () async {
                               await Get.toNamed(
                                '${Routes.dashboard}${Routes.viewVolume}${Routes.editVolume}',
                                parameters: {
                                  'volumeId': volume.id!,
                                },
                              );
                              // if (result == true) {
                              //   context.read<SinglevolumeBloc>().add(
                              //       GetSingleVolumeEvent(volumeId: volume.id!));
                              // }
                            },
                            text: "Edit Details",
                            icon: Icon(Icons.edit, color: Colors.white),
                            color: Colors.indigo,
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      _buildDetailRow('Volume Number',
                          volume.volumeNumber.toString(), Icons.book_outlined),
                      _buildDetailRow(
                          'Year',
                          volume.createdAt?.year.toString() ?? 'N/A',
                          Icons.calendar_today_outlined),
                      _buildDetailRow(
                          'Description',
                          volume.description ?? 'N/A',
                          Icons.description_outlined),
                      _buildDetailRow(
                          'Status',
                          volume.isActive == true ? 'Active' : 'Inactive',
                          Icons.toggle_on_outlined),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Issues',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo[800])),
                          GFButton(
                            onPressed: () {
                              Get.toNamed(
                                '${Routes.dashboard}${Routes.viewVolume}${Routes.addIssue}',
                                parameters: {
                                  'volumeId': volumeId,
                                },
                              );
                            },
                            text: "Add Issue",
                            icon: Icon(Icons.add, color: Colors.white),
                            color: Colors.indigo,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      volume.issues!.isEmpty
                          ? Center(
                              child: Text(
                                  'No issues available for this volume.',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600])))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: volume.issues?.length ?? 0,
                              itemBuilder: (context, index) {
                                IssueModel issue =
                                    volume.issues![index] as IssueModel;
                                return Card(
                                  margin: EdgeInsets.only(bottom: 16),
                                  elevation: 2,
                                  color: Colors.indigo[50],
                                  child: ListTile(
                                    leading: Icon(Icons.article,
                                        color: Colors.indigo),
                                    title: Text('Issue ${issue.issueNumber}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo[700])),
                                    subtitle: Text(
                                        issue.description ?? 'No description'),
                                    trailing: Icon(Icons.arrow_forward_ios,
                                        color: Colors.indigo),
                                    onTap: () {
                                      Get.toNamed(
                                        '${Routes.dashboard}${Routes.viewVolume}${Routes.viewIssue}',
                                        parameters: {
                                          'issueId': issue.id!,
                                          'volumeId': volumeId,
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is SingleVolumeError) {
          return Material(
              child: Center(
                  child: Text('Error: ${state.message}',
                      style: TextStyle(color: Colors.red))));
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.indigo, size: 24),
          SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.indigo[700]),
            ),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(color: Colors.black87, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
