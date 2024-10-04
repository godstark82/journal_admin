import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';

abstract class VolumeRepo {
  Future<void> addVolume(VolumeModel volume);
  Future<void> updateVolume(VolumeModel volume);
  Future<void> deleteVolume(String id);
  Future<DataState<VolumeModel>> getVolume(String id);
  Future<DataState<List<VolumeModel>>> getVolumesByJournalId(String journalId);
  Future<DataState<List<VolumeModel>>> getAllVolumes();
}
