// loginApi.dart
import 'dart:convert';
import 'dart:developer';

import 'package:fluttergsi/api/const.dart';
import 'package:fluttergsi/model/registerModel.dart'; // Adjust this import for your ModelLogin
import 'package:fluttergsi/template/template.dart';

class ApiRegister {
  final Template t = Template();
  Future<ModelRegister> Register(Map<String, String>? body) async {
    try {
      var response = await t.apiCall<ModelRegister>(
        urlbase,
        urlRegister,
        null,
        body,
        (json) => ModelRegister.fromJson(json),
      );

      if (response.success && response.data != null) {
        var data = response.data!;
        if (data.status == true) {
          return data;
        } else {
          // Combine errors into a string if there are errors
          return ModelRegister(status: false, message: '${data.message}');
        }
      } else {
        return ModelRegister(status: false, message: '${response.error}');
      }
    } catch (e) {
      return ModelRegister(status: false, message: 'An error occurred: $e');
    }
  }
}
