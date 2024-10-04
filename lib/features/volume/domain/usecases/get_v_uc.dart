import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';

class GetVolumeUseCase extends UseCase<DataState<VolumeModel>, String> {
  final VolumeRepo _volumeRepo;

  GetVolumeUseCase(this._volumeRepo);

  @override
  Future<DataState<VolumeModel>> call(String params) async {
    return _volumeRepo.getVolume(params);
  }
}
