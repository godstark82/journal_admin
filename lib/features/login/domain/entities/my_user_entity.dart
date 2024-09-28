class MyUser {
  String? role;
  String? email;
  String? password;
  String? name;
  String? id;

  MyUser({
    this.role,
    this.email,
    this.password,
    this.name,
    this.id,
  });

  Map<String, dynamic> toJson() => {
        'role': role,
        'email': email,
        'password': password,
        'name': name,
        'id': id,
      };

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
        role: json['role'],
        email: json['email'],
        password: json['password'],
        name: json['name'],
        id: json['id'],
      );
}
