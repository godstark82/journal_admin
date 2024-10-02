import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journal_web/core/models/editorial_board_model.dart';

class AdminServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEditorialBoardMember(EditorialBoardModel member) async {
    try {
      final docRef = _firestore.collection('editorialBoard').doc();
      member = member.copyWith(id: docRef.id);
      await docRef.set(member.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteEditorialBoardMember(String id) async {
    try {
      await _firestore.collection('editorialBoard').doc(id).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateEditorialBoardMember(
      String id, EditorialBoardModel member) async {
    try {
      await _firestore
          .collection('editorialBoard')
          .doc(id)
          .update(member.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<EditorialBoardModel>> getEditorialBoardMembers() async {
    try {
      final snapshot = await _firestore.collection('editorialBoard').get();
      return snapshot.docs
          .map((doc) => EditorialBoardModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<EditorialBoardModel> getEditorialBoardMember(String id) async {
    try {
      final snapshot =
          await _firestore.collection('editorialBoard').doc(id).get();
      return EditorialBoardModel.fromJson(snapshot.data()!);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }



  Future<void> deleteSocialLink(String id) async {
    try {
      await _firestore.collection('socialLinks').doc(id).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getSocialLinks() async {
    try {
      final snapshot = await _firestore.collection('socialLinks').get();
      return snapshot.docs.map((doc) => (doc.data())).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> updateSocialLink(String name, String url) async {
    try {
      final snapshot = await _firestore
          .collection('socialLinks')
          .where('name', isEqualTo: name)
          .get();
      if (snapshot.docs.isNotEmpty) {
        await _firestore
            .collection('socialLinks')
            .doc(snapshot.docs[0].id)
            .update({'url': url});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
