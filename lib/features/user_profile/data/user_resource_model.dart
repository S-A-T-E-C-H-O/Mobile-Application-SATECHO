class UserResourceModel {
  const UserResourceModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.roles,
  });

  final int id;
  final String fullName;
  final String email;
  final List<String> roles;

  factory UserResourceModel.fromJson(Map<String, dynamic> json) {
    return UserResourceModel(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      roles: (json['roles'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}
