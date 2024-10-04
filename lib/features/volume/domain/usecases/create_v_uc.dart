import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';

class CreateVolumeUC extends UseCase<void, VolumeModel> {
  final VolumeRepo _volumeRepo;

  CreateVolumeUC(this._volumeRepo);

  @override
  Future<void> call(VolumeModel params) async {
    return _volumeRepo.addVolume(params);
  }
}
