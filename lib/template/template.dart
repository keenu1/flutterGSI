// api/template.dart
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class Template {
  late SharedPreferences logindata;

  Future<ApiResponse<T>> apiCall<T>(
    String urlBase,
    String urlEndpoint,
    Map<String, String>? headers,
    Map<String, String>? body,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      var url = Uri.parse('$urlBase$urlEndpoint');
      var response = await http.post(url, headers: headers, body: body);
      log('Request URL: $url');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var data = fromJson(jsonResponse);
        return ApiResponse(success: true, data: data);
      } else {
        var jsonResponse = json.decode(response.body);
        return ApiResponse(
            success: false, error: jsonResponse['message'] ?? 'Unknown error');
      }
    } on SocketException {
      // No internet connection
      return ApiResponse(success: false, error: 'No Internet Connection.');
    } on FormatException {
      // Bad response format
      return ApiResponse(success: false, error: 'Bad response format.');
    } catch (e) {
      // Other errors
      return ApiResponse(success: false, error: 'Unexpected error: $e');
    }
  }

  Future<ApiResponse<T>> apiCallPutJson<T>(
    String urlBase,
    String urlEndpoint,
    String bearerToken,
    Map<String, dynamic> body,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      var url = Uri.parse('$urlBase$urlEndpoint');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      };

      var response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      log('Raw Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var data = fromJson(jsonResponse);
        return ApiResponse(success: true, data: data);
      } else if (response.statusCode == 401) {
        return ApiResponse(
          success: false,
          error: 'Unauthorized: Invalid or expired token.',
        );
      } else {
        var jsonResponse = json.decode(response.body);
        return ApiResponse(
          success: false,
          error: jsonResponse['message'] ?? 'Unknown error',
        );
      }
    } on SocketException {
      return ApiResponse(success: false, error: 'No Internet Connection.');
    } on FormatException {
      return ApiResponse(success: false, error: 'Bad response format.');
    } catch (e) {
      return ApiResponse(success: false, error: 'Unexpected error: $e');
    }
  }

  Future<ApiResponse<T>> apiCallGetJson<T>(
    String urlBase,
    String urlEndpoint,
    String bearerToken,
    Map<String, dynamic> body,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      var url = Uri.parse('$urlBase$urlEndpoint');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      };

      var response = await http.get(
        url,
        headers: headers,
      );

      log('Raw Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var data = fromJson(jsonResponse);
        return ApiResponse(success: true, data: data);
      } else if (response.statusCode == 401) {
        return ApiResponse(
          success: false,
          error: 'Unauthorized: Invalid or expired token.',
        );
      } else {
        var jsonResponse = json.decode(response.body);
        return ApiResponse(
          success: false,
          error: jsonResponse['message'] ?? 'Unknown error',
        );
      }
    } on SocketException {
      return ApiResponse(success: false, error: 'No Internet Connection.');
    } on FormatException {
      return ApiResponse(success: false, error: 'Bad response format.');
    } catch (e) {
      return ApiResponse(success: false, error: 'Unexpected error: $e');
    }
  }

  void showLoadingDialog(BuildContext context, String? label) {
    Size size = MediaQuery.of(context).size;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            insetPadding: EdgeInsets.only(
                left: size.width * 0.35,
                right: size.width * 0.35,
                top: 10,
                bottom: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    width: size.width * 0.3,
                    height: size.height * 0.15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                            child: CupertinoActivityIndicator(
                          color: Colors.grey,
                        )),
                        Visibility(
                            visible: label != null,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "$label",
                                textAlign: TextAlign.center,
                              ),
                            ))
                      ],
                    )),
              ],
            ),
          );
        });
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(); // Close the dialog
  }

  Future<bool> setString(String nama, value) async {
    logindata = await SharedPreferences.getInstance();
    return logindata.setString(nama, value);
  }

  Future<String?> getString(String value) async {
    logindata = await SharedPreferences.getInstance();
    return logindata.getString(value);
  }

  Future<bool> remove(String nama) async {
    logindata = await SharedPreferences.getInstance();
    return logindata.remove(nama);
  }
}

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  ApiResponse({required this.success, this.data, this.error});
}
