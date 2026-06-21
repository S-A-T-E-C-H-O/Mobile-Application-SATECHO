class AgronomistProfile {
  const AgronomistProfile({
    required this.name,
    required this.roleLabel,
    required this.activeClients,
    required this.phone,
    required this.email,
    required this.base,
    required this.rating,
    required this.experienceLabel,
    required this.specialties,
    required this.areasServed,
  });

  final String name;
  final String roleLabel;
  final int activeClients;
  final String phone;
  final String email;
  final String base;
  final double rating;
  final String experienceLabel;
  final List<String> specialties;
  final List<String> areasServed;
}
