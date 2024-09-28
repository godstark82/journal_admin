import 'package:flutter/material.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/core/const/const_img.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(article.image ?? noImage,
                  height: 200, width: double.infinity, fit: BoxFit.cover,
              )),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title ?? 'No Title',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  article.authors?.map((author) => author).join(', ') ??
                      'Unknown Author',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.mainSubjects?[0] ?? 'No subject',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  article.abstractString ?? 'No abstract available',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: article.keywords
                          ?.map((keyword) => Chip(
                                label: Text(keyword),
                                backgroundColor: Colors.grey[200],
                                labelStyle: TextStyle(color: Colors.grey[800]),
                              ))
                          .toList() ??
                      [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
