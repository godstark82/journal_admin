import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume/volume_bloc.dart';
import 'package:journal_web/routes.dart';

class VolumeCard extends StatelessWidget {
  final VolumeModel volume;

  const VolumeCard({super.key, required this.volume});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.book, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Volume ${volume.volumeNumber}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text('Year: ${volume.createdAt?.year}'),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${volume.description}',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      volume.isActive == true
                          ? Icons.check_circle
                          : Icons.cancel,
                      color:
                          volume.isActive == true ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Status: ${volume.isActive == true ? 'Active' : 'Inactive'}',
                      style: TextStyle(
                        color:
                            volume.isActive == true ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<VolumeBloc>().close();
                    Get.toNamed('${Routes.dashboard}${Routes.viewVolume}',
                        parameters: {'volumeId': volume.id!});
                  },
                  icon: Icon(Icons.visibility),
                  label: const Text('View Details'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
