import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';

class UpdateVolumeUC extends UseCase<void, VolumeModel> {
  final VolumeRepo _volumeRepo;

  UpdateVolumeUC(this._volumeRepo);

  @override
  Future<void> call(VolumeModel params) async {
    return _volumeRepo.updateVolume(params);
  }
}
