// loginApi.dart
import 'dart:developer';

import 'package:fluttergsi/api/const.dart';
import 'package:fluttergsi/model/loginModel.dart'; // Adjust this import for your ModelLogin
import 'package:fluttergsi/template/template.dart';

class ApiLogin {
  final Template t = Template();

  Future<ModelLogin> login(Map<String, String>? body) async {
    try {
      var response = await t.apiCall<ModelLogin>(
        urlbase,
        urlLogin,
        null,
        body,
        (json) => ModelLogin.fromJson(json), // wrap with a lambda!
      );

      if (response.success && response.data != null) {
        var data = response.data!;
        if (data.status == true) {
          return data;
        } else {
          return ModelLogin(status: false, message: '${data.message}');
        }
      } else {
        return ModelLogin(status: false, message: '${response.error}');
      }
    } catch (e) {
      return ModelLogin(status: false, message: 'An error occurred: $e');
    }
  }
}
