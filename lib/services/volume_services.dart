import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';

class VolumeServices {
  final _volumeCollection = FirebaseFirestore.instance.collection('volumes');

  Future<void> addVolume(VolumeModel volume) async {
    final docRef = _volumeCollection.doc();
    volume = volume.copyWith(id: docRef.id);
    await docRef.set(volume.toJson());
  }

  Future<void> updateVolume(VolumeModel volume) async {
    await _volumeCollection.doc(volume.id).update(volume.toJson());

    if (volume.isActive) {
      // Get all volumes under the same journal
      final querySnapshot = await _volumeCollection
          .where('journalId', isEqualTo: volume.journalId)
          .get();

      // Update all other volumes to be inactive
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in querySnapshot.docs) {
        if (doc.id != volume.id) {
          batch.update(doc.reference, {'isActive': false});
        }
      }

      // Commit the batch update
      await batch.commit();
    }
  }

  Future<void> deleteVolume(String id) async {
    // Delete the volume
    await _volumeCollection.doc(id).delete();

    // Delete all issues where volumeId equals id
    final issuesCollection = FirebaseFirestore.instance.collection('issues');
    final issueSnapshot = await issuesCollection.where('volumeId', isEqualTo: id).get();

    // Delete all articles where volumeId equals id
    final articlesCollection = FirebaseFirestore.instance.collection('articles');
    final articleSnapshot =
        await articlesCollection.where('volumeId', isEqualTo: id).get();

    final batch = FirebaseFirestore.instance.batch();
    for (var doc in issueSnapshot.docs) {
      batch.delete(doc.reference);
    }
    for (var doc in articleSnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<DataState<VolumeModel>> getVolume(String id) async {
    try {
      final docSnapshot = await _volumeCollection.doc(id).get();
      return DataSuccess(
          VolumeModel.fromJson(docSnapshot.data() as Map<String, dynamic>));
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  Future<DataState<List<VolumeModel>>> getAllVolumes() async {
    try {
      final snapshot = await _volumeCollection.get();
      return DataSuccess(snapshot.docs
          .map((doc) => VolumeModel.fromJson(doc.data()))
          .toList());
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  Future<DataState<List<VolumeModel>>> getVolumesByJournalId(
      String journalId) async {
    try {
      final snapshot = await _volumeCollection
          .where('journalId', isEqualTo: journalId)
          .get();
      return DataSuccess(snapshot.docs
          .map((doc) => VolumeModel.fromJson(doc.data()))
          .toList());
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
