import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/pages/data/models/page_model.dart';

class PageService {
  final firestore = FirebaseFirestore.instance;

  Future<void> addPage(PageModel page) async {
    final docRef = firestore.collection('pages').doc();
    page = page.copyWith(id: docRef.id);
    await docRef.set(page.toJson());
  }

  Future<DataState<List<PageModel>>> getPages() async {
    try {
      final snapshot = await firestore.collection('pages').get();
      return DataSuccess(
          snapshot.docs.map((doc) => PageModel.fromJson(doc.data())).toList());
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  Future<void> updatePage(PageModel page) async {
    await firestore.collection('pages').doc(page.id).update(page.toJson());
  }

  Future<void> deletePage(String id) async {
    await firestore.collection('pages').doc(id).delete();
  }

  Future<DataState<PageModel>> getPage(String id) async {
    try {
      final snapshot = await firestore.collection('pages').doc(id).get();
      return DataSuccess(PageModel.fromJson(snapshot.data()!));
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
