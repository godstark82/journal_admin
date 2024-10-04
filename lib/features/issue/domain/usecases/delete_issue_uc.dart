import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/issue/domain/repositories/issue_repo.dart';

class DeleteIssueUseCase extends UseCase<void, String> {
  final IssueRepository _issueRepository;

  DeleteIssueUseCase(this._issueRepository);

  @override
  Future<void> call(String params) async {
    await _issueRepository.deleteIssue(params);
  }
}
