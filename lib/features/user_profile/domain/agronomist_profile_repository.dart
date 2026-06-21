import 'package:satecho_mobile/features/user_profile/domain/agronomist_profile.dart';

abstract class AgronomistProfileRepository {
  Future<AgronomistProfile> getAgronomistProfile();
}
