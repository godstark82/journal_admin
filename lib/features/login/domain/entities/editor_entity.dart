class EditorEntity {
  final String title;
  final String fullName;
  final String journalName;
  final String email;
  final String username;
  final String password;
  final String country;
  final String mobile;
  final String correspondingAddress;
  final String detailsCV;
  final String researchDomain;

  EditorEntity(
      {required this.correspondingAddress,
      required this.country,
      required this.detailsCV,
      required this.email,
      required this.fullName,
      required this.journalName,
      required this.mobile,
      required this.password,
      required this.researchDomain,
      required this.title,
      required this.username});
}
