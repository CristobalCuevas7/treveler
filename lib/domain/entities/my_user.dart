class MyUser {
  final int id;
  final String token;
  final String email;

  MyUser({required this.id, required this.token, required this.email});

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(id: json['id'], token: json['token'] ?? "", email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'token': token};
  }
}
