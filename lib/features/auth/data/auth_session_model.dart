class AuthSessionModel {
  const AuthSessionModel({
    required this.id,
    required this.token,
    required this.roles,
  });

  final String id;
  final String token;
  final List<String> roles;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      id: json['id'].toString(),
      token: json['token'] as String,
      roles: (json['roles'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'token': token,
        'roles': roles,
      };
}
