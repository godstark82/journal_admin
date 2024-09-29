import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/core/const/const_img.dart';
import 'package:journal_web/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:intl/intl.dart';
import 'package:getwidget/getwidget.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop =
            sizingInformation.deviceScreenType == DeviceScreenType.desktop;

        return Container(
          width: isDesktop ? 250 : double.infinity,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    article.image ?? noImage,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: article.keywords!
                            .map((keyword) => Chip(
                                  label: Text(
                                    keyword,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  padding: EdgeInsets.all(4),
                                  backgroundColor: Colors.primaries[
                                          keyword.hashCode %
                                              Colors.primaries.length]
                                      .withOpacity(0.3),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 12),
                      Text(
                        article.title ?? 'N/A',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        article.abstractString ?? 'N/A',
                        style: TextStyle(fontSize: 12),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Authors: ',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: article.authors?.join(", ") ?? 'N/A',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Created: ${article.createdAt != null ? DateFormat('MMM d, yyyy').format(article.createdAt!) : 'N/A'}',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          GFButton(
                            onPressed: () async {
                              await Get.toNamed(
                                Routes.dashboard + Routes.editArticle,
                                arguments: {'article': article},
                              );
                              context.read<ArticleBloc>().add(ArticleLoadEvent());
                            },
                            text: "Edit",
                            icon: Icon(Icons.edit, size: 14),
                            type: GFButtonType.outline,
                            size: GFSize.SMALL,
                          ),
                          GFButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Delete"),
                                    content: Text(
                                        "Are you sure you want to delete this article?"),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Delete"),
                                        onPressed: () {
                                          context.read<ArticleBloc>().add(
                                              ArticleDeleteEvent(
                                                  id: article.id!));
                                          Navigator.of(context).pop();
                                          context.read<ArticleBloc>().add(ArticleLoadEvent());
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            text: "Delete",
                            icon: Icon(Icons.delete, size: 14),
                            color: Colors.red,
                            size: GFSize.SMALL,
                          ),
                          GFButton(
                            onPressed: () {
                              // TODO: Implement add comments functionality
                            },
                            text: "Comments",
                            icon: Icon(Icons.comment, size: 14),
                            type: GFButtonType.outline2x,
                            size: GFSize.SMALL,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
