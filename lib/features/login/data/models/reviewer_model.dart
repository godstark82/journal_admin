import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_web/features/login/domain/entities/reviewer_entity.dart';

class ReviewerModel extends ReviewerEntity {
  ReviewerModel(
      {super.title,
      super.name,
      super.id,
      super.email,
      super.journal,
      super.role,
      super.password,
      super.country,
      super.mobile,
      super.correspondingAddress,
      super.detailsCV,
      super.researchDomain});

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'name': name,
      'id': id,
      'email': email,
      'role': role,
      'journal': journal,
      'password': password,
      'country': country,
      'mobile': mobile,
      'correspondingAddress': correspondingAddress,
      'detailsCV': detailsCV,
      'researchDomain': researchDomain,
    };
  }

  factory ReviewerModel.fromJson(Map<String, dynamic> json) {
    return ReviewerModel(
      title: json['title'],
      email: json['email'],
      role: json['role'],
      journal: json['journal'],
      password: json['password'],
      country: json['country'],
      mobile: json['mobile'],
      correspondingAddress: json['correspondingAddress'],
      detailsCV: json['detailsCV'],
      researchDomain: json['researchDomain'],
      id: json['id'],
      name: json['name'],
    );
  }

  static Future<ReviewerModel?> fromUser(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (snapshot.exists) {
        final userData = snapshot.data()!;
        return ReviewerModel.fromJson(userData);
      } else {
        print('Reviewer not found');
        return null;
      }
    } catch (e) {
      print('Error fetching reviewer data: $e');
      return null;
    }
  }
}
