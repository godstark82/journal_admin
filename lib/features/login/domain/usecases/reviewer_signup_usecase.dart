import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:journal_web/features/login/domain/repositories/login_repo.dart';

class ReviewerSignupUsecase extends UseCase<User?, ReviewerModel> {
  LoginRepo repo;
  ReviewerSignupUsecase(this.repo);
  @override
  Future<User?> call(ReviewerModel params) async {
    return await repo.reviewerSignup(params);
  }
}
