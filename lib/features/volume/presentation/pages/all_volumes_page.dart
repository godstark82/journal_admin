import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/core/const/roles.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume_bloc.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:journal_web/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AllVolumesPage extends StatefulWidget {
  const AllVolumesPage({super.key});

  @override
  _AllVolumesPageState createState() => _AllVolumesPageState();
}

class _AllVolumesPageState extends State<AllVolumesPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<VolumeBloc>().add(GetAllVolumesEvent());
    context.read<JournalBloc>().add(GetAllJournalEvent());
  }

  String getJournalName(String journalId, List<JournalModel> journals) {
    final journal = journals.firstWhere((j) => j.id == journalId,
        orElse: () => JournalModel(
            id: '', title: 'N/A', domain: '', createdAt: DateTime.now()));
    return journal.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('All Volumes'),
        actions: [
          if (LoginConst.currentUser?.role == Role.admin ||
              LoginConst.currentUser?.role == Role.author)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  _addNewVolumeFunc();
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Volume'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, journalState) {
          if (journalState is JournalsLoaded) {
            return BlocBuilder<VolumeBloc, VolumeState>(
              builder: (context, state) {
                if (state is VolumeLoadingAll) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is VolumeLoadedAll) {
                  return ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      if (sizingInformation.deviceScreenType ==
                          DeviceScreenType.desktop) {
                        return _buildDesktopView(
                            state.volumes, journalState.journals);
                      } else {
                        return _buildMobileView(
                            state.volumes, journalState.journals);
                      }
                    },
                  );
                } else if (state is VolumeError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return _buildEmptyView();
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildDesktopView(
      List<VolumeModel> volumes, List<JournalModel> journals) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: volumes.isEmpty
            ? _buildEmptyView()
            : DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.lightBlue[100]),
                dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.08);
                    }
                    return null;
                  },
                ),
                columns: const [
                  DataColumn(
                      label: Text('Title',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Journal Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Volume Number',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Is Active',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Actions',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: volumes
                    .map((volume) => DataRow(
                          cells: [
                            DataCell(Text(volume.title)),
                            DataCell(Text(
                                getJournalName(volume.journalId, journals))),
                            DataCell(Text(volume.volumeNumber)),
                            DataCell(Text(volume.isActive ? 'Yes' : 'No')),
                            DataCell(Row(
                              children: [
                                //* only admin and editor can see this
                                if (LoginConst.currentUser?.role == Role.admin ||
                                    LoginConst.currentUser?.role == Role.author)
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () {
                                      _editVolumeFunc(volume.id);
                                    },
                                  ),
                                //* only admin and editor can see this
                                if (LoginConst.currentUser?.role == Role.admin ||
                                    LoginConst.currentUser?.role == Role.author)
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      _deleteVolumeFunc(volume.id);
                                    },
                                  ),
                              ],
                            )),
                          ],
                        ))
                    .toList(),
              ),
      ),
    );
  }

  Widget _buildMobileView(
      List<VolumeModel> volumes, List<JournalModel> journals) {
    if (volumes.isEmpty) {
      return _buildEmptyView();
    }
    return ListView.builder(
      itemCount: volumes.length,
      itemBuilder: (context, index) {
        final volume = volumes[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(volume.title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Journal: ${getJournalName(volume.journalId, journals)}'),
                Text('Volume Number: ${volume.volumeNumber}'),
                Text('Is Active: ${volume.isActive ? 'Yes' : 'No'}'),
              ],
            ),
            tileColor: index.isEven ? Colors.grey[100] : Colors.white,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //* only admin and editor can see this
                if (LoginConst.currentUser?.role == Role.admin ||
                    LoginConst.currentUser?.role == Role.author)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editVolumeFunc(volume.id);
                    },
                  ),
                //* only admin and editor can see this
                if (LoginConst.currentUser?.role == Role.admin ||
                    LoginConst.currentUser?.role == Role.author)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteVolumeFunc(volume.id);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyView() {
    //* only admin and editor can see this
    if (!(LoginConst.currentUser?.role == Role.admin ||
        LoginConst.currentUser?.role == Role.author)) {
      return SizedBox();
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No volumes yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              _addNewVolumeFunc();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('Add Your First Volume'),
          ),
        ],
      ),
    );
  }

  void _addNewVolumeFunc() async {
    await Get.toNamed(Routes.dashboard + Routes.addVolume);
    _loadData(); // Reload data after adding a new volume
  }

  void _editVolumeFunc(String volumeId) async {
    await Get.toNamed(Routes.dashboard + Routes.editVolume,
        parameters: {'volumeId': volumeId});
    _loadData(); // Reload data after editing a volume
  }

  void _deleteVolumeFunc(String volumeId) {
    bool isDeleteEnabled = false;
    int countdown = 5;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (!isDeleteEnabled) {
              Timer.periodic(Duration(seconds: 1), (timer) {
                if (countdown > 0) {
                  setState(() {
                    countdown--;
                  });
                } else {
                  setState(() {
                    isDeleteEnabled = true;
                  });
                  timer.cancel();
                }
              });
            }

            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Confirm Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Are you sure you want to delete this volume?'),
                  SizedBox(height: 10),
                  Text(
                    'WARNING: Deleting this volume will also delete all issues and articles under it!',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  if (!isDeleteEnabled)
                    Text('Delete button will be enabled in $countdown seconds'),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDeleteEnabled ? Colors.red : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isDeleteEnabled
                      ? () {
                          context
                              .read<VolumeBloc>()
                              .add(DeleteVolumeEvent(volumeId: volumeId));
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Volume deleted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _loadData(); // Reload data after deleting a volume
                        }
                      : null,
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
