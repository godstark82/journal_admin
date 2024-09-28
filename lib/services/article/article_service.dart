import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';

class ArticleService {
  final firestore = FirebaseFirestore.instance;

  //! Get all articles
  Future<DataState<List<ArticleModel>>> getAllArticles() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firestore.collection('articles').get();
      List<ArticleModel> articles = querySnapshot.docs
          .map((doc) => ArticleModel.fromJson(doc.data()))
          .toList();
      return DataSuccess(articles);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  //! Add new Article
  Future<DataState<ArticleModel>> addArticle(ArticleModel article) async {
    try {
      // Add a placeholder document to get the document reference
      DocumentReference<Map<String, dynamic>> docRef = await firestore
          .collection('articles')
          .add({}); // Initially add an empty document

      // Set the article ID to the generated document ID
      article.id = docRef.id;

      // Now update the document with the article data
      await docRef.set(article.toJson());

      // Retrieve the newly added article from Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('articles')
          .where('id', isEqualTo: docRef.id)
          .get();

      List<ArticleModel> articles = querySnapshot.docs
          .map((doc) => ArticleModel.fromJson(doc.data()))
          .toList();

      return DataSuccess(articles[0]);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  //! Update Article
  Future<DataState<ArticleModel>> updateArticle(ArticleModel article) async {
    try {
      await firestore
          .collection('articles')
          .doc(article.id)
          .update(article.toJson());
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('articles')
          .where('id', isEqualTo: article.id)
          .get();
      List<ArticleModel> articles = querySnapshot.docs
          .map((doc) => ArticleModel.fromJson(doc.data()))
          .toList();
      return DataSuccess(articles[0]);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  //! Delete Article
  Future<void> deleteArticle(String id) async {
    try {
      await firestore.collection('articles').doc(id).delete();
    } catch (e) {
      log(e.toString());
    }
  }
}
