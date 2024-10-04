import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/issue/data/models/issue_model.dart';
import 'package:journal_web/features/issue/domain/repositories/issue_repo.dart';

class UpdateIssueUseCase extends UseCase<void, IssueModel> {
  final IssueRepository _issueRepository;

  UpdateIssueUseCase(this._issueRepository);

  @override
  Future<void> call(IssueModel params) async {
    await _issueRepository.updateIssue(params);
  }
}
