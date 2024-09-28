
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/domain/repositories/article_repo.dart';

class GetArticlesUsecase extends UseCase<DataState<List<ArticleModel>>, void> {
  final ArticleRepo articleRepo;

  GetArticlesUsecase(this.articleRepo);
  
  @override
  Future<DataState<List<ArticleModel>>> call(void params) async{
    return await articleRepo.getAllArticles();
  }
}