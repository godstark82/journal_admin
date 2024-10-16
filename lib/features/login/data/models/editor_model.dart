import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_web/features/login/domain/entities/editor_entity.dart';

class EditorModel extends EditorEntity {
  EditorModel({
    super.correspondingAddress,
    super.country,
    super.cvPdfUrl,
    super.email,
    super.role,
    super.journalName,
    super.mobile,
    super.password,
    super.researchDomain,
    super.title,
    super.name,
    super.journalIds,
    super.id,
  });

  factory EditorModel.fromJson(Map<String, dynamic> json) {
    return EditorModel(
      correspondingAddress: json['correspondingAddress'],
      country: json['country'],
      cvPdfUrl: json['cvPdfUrl'],
      email: json['email'],
      role: json['role'],
      journalName: json['journalName'],
      mobile: json['mobile'],
      password: json['password'],
      researchDomain: json['researchDomain'],
      title: json['title'],
      id: json['id'],
      name: json['name'],
      journalIds: json['journalIds'] != null
          ? List<String>.from(json['journalIds'])
          : [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'correspondingAddress': correspondingAddress,
      'country': country,
      'cvPdfUrl': cvPdfUrl,
      'email': email,
      'role': role,
      'journalName': journalName,
      'mobile': mobile,
      'password': password,
      'researchDomain': researchDomain,
      'title': title,
      'id': id,
      'name': name,
      'journalIds': journalIds,
      };
  }

  static Future<EditorModel?> fromUser(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (snapshot.exists) {
        final userData = snapshot.data()!;
        return EditorModel.fromJson(userData);
      } else {
        print('Editor not found');
        return null;
      }
    } catch (e) {
      print('Error fetching editor data: $e');
      return null;
    }
  }
}
