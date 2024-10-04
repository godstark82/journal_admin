import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';

class GetVolumesByJournalIdUC
    extends UseCase<DataState<List<VolumeModel>>, String> {
  final VolumeRepo _volumeRepo;

  GetVolumesByJournalIdUC(this._volumeRepo);

  @override
  Future<DataState<List<VolumeModel>>> call(String params) {
    return _volumeRepo.getVolumesByJournalId(params);
  }
}
