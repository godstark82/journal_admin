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
  }

  Future<void> deleteVolume(String id) async {
    await _volumeCollection.doc(id).delete();
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
