class FarmModel {
  const FarmModel({required this.id, required this.name});

  final int id;
  final String name;

  factory FarmModel.fromJson(Map<String, dynamic> json) {
    return FarmModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
