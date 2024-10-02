import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';

class GetAllVolumeUseCase extends UseCase<DataState<List<VolumeModel>>, void> {
  final VolumeRepo repository;

  GetAllVolumeUseCase(this.repository);

  @override
  Future<DataState<List<VolumeModel>>> call([void params]) async {
    return await repository.getAllVolume();
  }
}

class GetVolumeByIdUseCase extends UseCase<DataState<VolumeModel>, String> {
  final VolumeRepo repository;

  GetVolumeByIdUseCase(this.repository);

  @override
  Future<DataState<VolumeModel>> call(String params) async {
    return await repository.getVolume(params);
  }
}

class CreateVolumeUseCase extends UseCase<void, VolumeModel> {
  final VolumeRepo repository;

  CreateVolumeUseCase(this.repository);

  @override
  Future<void> call(VolumeModel params) async {
    return await repository.createVolume(params);
  }
}

class UpdateVolumeUseCase extends UseCase<void, VolumeModel> {
  final VolumeRepo repository;

  UpdateVolumeUseCase(this.repository);

  @override
  Future<void> call(VolumeModel params) async {
    return await repository.updateVolume(params);
  }
}

class DeleteVolumeUseCase extends UseCase<void, String> {
  final VolumeRepo repository;

  DeleteVolumeUseCase(this.repository);

  @override
  Future<void> call(String params) async {
    return await repository.deleteVolume(params);
  }
}
