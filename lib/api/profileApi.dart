// loginApi.dart
import 'dart:developer';

import 'package:fluttergsi/api/const.dart';
// Adjust this import for your ModelLogin
import 'package:fluttergsi/model/profileModelUpdate.dart';
import 'package:fluttergsi/model/userProfileModel.dart';
import 'package:fluttergsi/template/template.dart';

class ApiProfile {
  final Template t = Template();

  Future<ModelProfileUpdate> update(Map<String, String>? body) async {
    String? token = await t.getString('token');

    try {
      var response = await t.apiCallPutJson<ModelProfileUpdate>(
        urlbase,
        urlProfileUpdate,
        token!,
        body!,
        (json) => ModelProfileUpdate.fromJson(json), // wrap with a lambda!
      );

      if (response.success && response.data != null) {
        var data = response.data!;
        log(data.status!);
        if (data.status == "success") {
          return data;
        } else {
          return ModelProfileUpdate(
              status: "false", message: '${data.message}');
        }
      } else if (response.error == 'Unauthorized: Invalid or expired token.') {
        // Handle unauthorized access by redirecting to login
        return ModelProfileUpdate(
            status: "false", message: 'Unauthorized, redirecting to login...');
      } else {
        return ModelProfileUpdate(
            status: "false", message: '${response.error}');
      }
    } catch (e) {
      return ModelProfileUpdate(
          status: "false", message: 'An error occurred: $e');
    }
  }

  Future<UserProfileResponse> get(Map<String, String>? body) async {
    String? token = await t.getString('token');

    try {
      var response = await t.apiCallGetJson<UserProfileResponse>(
        urlbase,
        urlProfileGet,
        token!,
        body!,
        (json) => UserProfileResponse.fromJson(json), // wrap with a lambda!
      );

      if (response.success && response.data != null) {
        var data = response.data!;

        if (data.status == true) {
          return data;
        } else {
          return UserProfileResponse(status: false, message: '${data.message}');
        }
      } else if (response.error == 'Unauthorized: Invalid or expired token.') {
        // Handle unauthorized access by redirecting to login
        return UserProfileResponse(
            status: false, message: 'Unauthorized, redirecting to login...');
      } else {
        return UserProfileResponse(status: false, message: '${response.error}');
      }
    } catch (e) {
      return UserProfileResponse(
          status: false, message: 'An error occurred: $e');
    }
  }
}
