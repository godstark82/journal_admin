import 'package:journal_web/features/login/domain/entities/author_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorModel extends AuthorEntity {
  AuthorModel({
    super.title,
    super.address,
    super.role,
    super.city,
    super.country,
    super.orcId,
    super.email,
    super.name,
    super.id,
    super.password,
    super.designation,
    super.specialization,
    super.fieldOfStudy,
    super.mobile,
    super.state,
    super.pinCode,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      title: json['title'],
      city: json['city'],
      role: json['role'],
      country: json['country'],
      name: json['name'],
      id: json['id'],
      email: json['email'],
      password: json['password'],
      orcId: json['orcId'],
      designation: json['designation'],
      specialization: json['specialization'],
      fieldOfStudy: json['fieldOfStudy'],
      mobile: json['mobile'],
      state: json['state'],
      pinCode: json['pinCode'],
      address: json['address'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'city': city,
      'country': country,
      
      'role': role,
      'orcId': orcId,
      'password': password,
      'designation': designation,
      'specialization': specialization,
      'fieldOfStudy': fieldOfStudy,
      'mobile': mobile,
      'state': state,
      'pinCode': pinCode,
      'address': address,
      'name': name,
      'id': id,
      'email': email,
    };
  }

  static Future<AuthorModel?> fromUser(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (snapshot.exists) {
        final userData = snapshot.data()!;
        return AuthorModel.fromJson(userData);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
