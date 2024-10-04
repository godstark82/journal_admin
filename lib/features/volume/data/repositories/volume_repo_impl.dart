import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';
import 'package:journal_web/services/volume_services.dart';

class VolumeRepoImpl implements VolumeRepo {
  final VolumeServices _volumeServices;

  VolumeRepoImpl(this._volumeServices);
  @override
  Future<void> addVolume(VolumeModel volume) {
    return _volumeServices.addVolume(volume);
  }

  @override
  Future<void> deleteVolume(String id) {
    return _volumeServices.deleteVolume(id);
  }

  @override
  Future<DataState<List<VolumeModel>>> getAllVolumes() {
    return _volumeServices.getAllVolumes();
  }

  @override
  Future<DataState<VolumeModel>> getVolume(String id) {
    return _volumeServices.getVolume(id);
  }

  @override
  Future<DataState<List<VolumeModel>>> getVolumesByJournalId(String journalId) {
    return _volumeServices.getVolumesByJournalId(journalId);
  }

  @override
  Future<void> updateVolume(VolumeModel volume) {
    return _volumeServices.updateVolume(volume);
  }
}
