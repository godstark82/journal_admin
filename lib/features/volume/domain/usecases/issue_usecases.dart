import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/volume/data/models/issue_model.dart';
import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';

class GetAllIssueUseCase extends UseCase<DataState<List<IssueModel>>, String> {
  final VolumeRepo repository;

  GetAllIssueUseCase(this.repository);

  @override
  Future<DataState<List<IssueModel>>> call(String params) async {
    return await repository.getAllIssue(params);
  }
}

class GetIssueByIdUseCase
    extends UseCase<DataState<IssueModel>, Map<String, dynamic>> {
  final VolumeRepo repository;

  GetIssueByIdUseCase(this.repository);

  @override
  Future<DataState<IssueModel>> call(Map<String, dynamic> params) async {
    return await repository.getIssue(
        volumeId: params['volumeId'], issueId: params['issueId']);
  }
}

class CreateIssueUseCase extends UseCase<void, Map<String, dynamic>> {
  final VolumeRepo repository;

  CreateIssueUseCase(this.repository);

  @override
  Future<void> call(Map<String, dynamic> params) async {
    return await repository.createIssue(params['issue'], params['volumeId']);
  }
}

class UpdateIssueUseCase extends UseCase<void, IssueModel> {
  final VolumeRepo repository;

  UpdateIssueUseCase(this.repository);

  @override
  Future<void> call(IssueModel params) async {
    return await repository.updateIssue(params);
  }
}

class DeleteIssueUseCase extends UseCase<void, Map<String, dynamic>> {
  final VolumeRepo repository;

  DeleteIssueUseCase(this.repository);

  @override
  Future<void> call(Map<String, dynamic> params) async {
    return await repository.deleteIssue(params['issueId'], params['volumeId']);
  }
}
