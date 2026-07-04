import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/soil_monitoring/data/farm_model.dart';
import 'package:satecho_mobile/features/user_profile/data/user_resource_model.dart';

class UserProfileRemoteDataSource {
  const UserProfileRemoteDataSource(this._client);

  final ApiClient _client;

  Future<UserResourceModel> getMe() async {
    final response = await _client.get<Map<String, dynamic>>(ApiConstants.me);
    return UserResourceModel.fromJson(response.data!);
  }

  Future<List<FarmModel>> getFarms() async {
    final response = await _client.get<List<dynamic>>(ApiConstants.farms);
    return (response.data as List<dynamic>)
        .map((e) => FarmModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateProfile({required String fullName}) async {
    await _client.patch<void>(ApiConstants.me, data: {'fullName': fullName});
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.post<void>(
      ApiConstants.changePassword,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }
}
