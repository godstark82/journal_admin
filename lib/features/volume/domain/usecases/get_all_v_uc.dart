import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';

class GetAllVolumesUseCase extends UseCase<DataState<List<VolumeModel>>, void> {
  final VolumeRepo _volumeRepo;

  GetAllVolumesUseCase(this._volumeRepo);

  @override
  Future<DataState<List<VolumeModel>>> call(void params) async {
    return _volumeRepo.getAllVolumes();
  }
}
