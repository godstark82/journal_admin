import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';
import 'package:journal_web/features/article/presentation/widgets/article_card.dart';
import 'package:journal_web/routes.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ArticleBloc>(context).add(ArticleLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      appBar: AppBar(
        elevation: 2,
        title: const Text('Articles'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.dashboard + Routes.addArticle);
        },
        tooltip: 'Add Article',
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ArticleLoaded) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 600,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.articles.length,
                  itemBuilder: (context, index) {
                    return ArticleCard(article: state.articles[index]);
                  },
                );
              },
            );
          } else if (state is ArticleError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No articles available'));
          }
        },
      ),
    );
  }
}
