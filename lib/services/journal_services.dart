import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';

class JournalServices {
  final _journalCollection = FirebaseFirestore.instance.collection('journals');

  Future<void> addJournal(JournalModel journal) async {
    final docRef = _journalCollection.doc();
    journal = journal.copyWith(id: docRef.id);
    await docRef.set(journal.toJson());
  }

  Future<void> updateJournal(JournalModel journal) async {
    await _journalCollection.doc(journal.id).update(journal.toJson());
  }

  Future<void> deleteJournal(String id) async {
    await _journalCollection.doc(id).delete();
  }

  Future<DataState<List<JournalModel>>> getAllJournals() async {
    final snapshot = await _journalCollection.get();
    if (snapshot.docs.isNotEmpty) {
      return DataSuccess(
          snapshot.docs.map((e) => JournalModel.fromJson(e.data())).toList());
    } else {
      return DataFailed('No journals found');
    }
  }

  Future<DataState<JournalModel>> getJournalById(String id) async {
    log('Getting journal by id: $id');
    final docSnapshot = await _journalCollection.doc(id).get();
    log(docSnapshot.data().toString());
    if (docSnapshot.exists) {
      return DataSuccess(JournalModel.fromJson(docSnapshot.data()!));
    } else {
      return DataFailed('Journal not found');
    }
  }
}
