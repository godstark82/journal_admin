class AuthorEntity {
  final String title;
  final String firstName;
  final String? middle;
  final String lastName;
  final String mail;
  final String orcId;
  final String username;
  final String password;
  final String designation;
  final String specialization;
  final String fieldOfStudy;
  final String? phone;
  final String mobile;
  final String country;
  final String state;
  final String city;
  final String pinCode;

  AuthorEntity({
    required this.title,
    required this.firstName,
    this.middle,
    required this.lastName,
    required this.mail,
    required this.orcId,
    required this.username,
    required this.password,
    required this.designation,
    required this.specialization,
    required this.fieldOfStudy,
    this.phone,
    required this.mobile,
    required this.country,
    required this.state,
    required this.city,
    required this.pinCode,
  });
}
