import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';
import 'package:journal_web/features/article/presentation/widgets/article_card.dart';
import 'package:journal_web/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
      body: BlocConsumer<ArticleBloc, ArticleState>(
        listener: (context, state) {
          if (state is ArticleDeleteArticleState) {
            context.read<ArticleBloc>().add(ArticleLoadEvent());
          } else if (state is ArticleAddNewArticleState) {
            context.read<ArticleBloc>().add(ArticleLoadEvent());
          } else if (state is ArticleUpdateArticleState) {
            context.read<ArticleBloc>().add(ArticleLoadEvent());
          } else if (state is ArticleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ArticleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ArticleLoaded) {
            if (state.articles.isEmpty) {
              return const Center(child: Text('No articles published yet'));
            }
            return ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) {
                  return _buildDesktopLayout(state.articles);
                } else if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.tablet) {
                  return _buildTabletLayout(state.articles);
                } else {
                  return _buildMobileLayout(state.articles);
                }
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

  Widget _buildDesktopLayout(List<ArticleModel> articles) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return ArticleCard(article: articles[index]);
      },
    );
  }

  Widget _buildTabletLayout(List<ArticleModel> articles) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return ArticleCard(article: articles[index]);
      },
    );
  }

  Widget _buildMobileLayout(List<ArticleModel> articles) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ArticleCard(article: articles[index]),
        );
      },
    );
  }
}
