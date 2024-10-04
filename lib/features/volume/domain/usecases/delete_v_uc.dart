import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';

class DeleteVolumeUC extends UseCase<void, String> {
  final VolumeRepo _volumeRepo;

  DeleteVolumeUC(this._volumeRepo);

  @override
  Future<void> call(String params) async {
    return _volumeRepo.deleteVolume(params);
  }
}
