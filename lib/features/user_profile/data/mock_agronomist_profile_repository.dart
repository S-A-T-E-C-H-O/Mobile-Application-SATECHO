import 'package:satecho_mobile/features/user_profile/domain/agronomist_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/agronomist_profile_repository.dart';

class MockAgronomistProfileRepository implements AgronomistProfileRepository {
  @override
  Future<AgronomistProfile> getAgronomistProfile() async {
    return const AgronomistProfile(
      name: 'Eng. Roberto Martínez',
      roleLabel: 'Agricultural Engineer',
      activeClients: 23,
      phone: '+54 351 555-0192',
      email: 'r.martinez@agro.com',
      base: 'Córdoba, Argentina',
      rating: 4.9,
      experienceLabel: '8 years of experience',
      specialties: [
        'Corn',
        'Soy',
        'Wheat',
        'Drip irrigation',
        'Precision agriculture',
        'IoT Sensors'
      ],
      areasServed: [
        'North Zone (8 properties)',
        'Central Zone (7 properties)',
        'South Zone (5 properties)',
        'East Zone (3 properties)',
      ],
    );
  }
}
