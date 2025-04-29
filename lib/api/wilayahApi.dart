// loginApi.dart
import 'dart:convert';
import 'dart:developer';

import 'package:fluttergsi/api/const.dart';
import 'package:fluttergsi/model/wilayahModel.dart'; // Adjust this import for your ModelLogin
import 'package:fluttergsi/template/template.dart';

class ApiWilayah {
  final Template t = Template();
  Future<ModelWilayah> Provinsi(Map<String, String>? body) async {
    try {
      var response = await t.apiCall<ModelWilayah>(
        urlbase,
        urlProvinsi,
        null,
        body,
        (json) => ModelWilayah.fromJson(json),
      );

      if (response.success && response.data != null) {
        var data = response.data!;
        if (data.status == true) {
          return data;
        } else {
          // Combine errors into a string if there are errors
          return ModelWilayah(status: false, data: data.data);
        }
      } else {
        return ModelWilayah(status: false);
      }
    } catch (e) {
      return ModelWilayah(status: false);
    }
  }

  Future<ModelWilayah> Kabupaten(Map<String, String>? body) async {
    try {
      var response = await t.apiCall<ModelWilayah>(
        urlbase,
        urlKabupaten,
        null,
        body,
        (json) => ModelWilayah.fromJson(json),
      );

      if (response.success && response.data != null) {
        var data = response.data!;
        if (data.status == true) {
          return data;
        } else {
          // Combine errors into a string if there are errors
          return ModelWilayah(status: false, data: data.data);
        }
      } else {
        return ModelWilayah(status: false);
      }
    } catch (e) {
      return ModelWilayah(status: false);
    }
  }

  Future<ModelWilayah> Kecamatan(Map<String, String>? body) async {
    try {
      var response = await t.apiCall<ModelWilayah>(
        urlbase,
        urlKecamatan,
        null,
        body,
        (json) => ModelWilayah.fromJson(json),
      );

      if (response.success && response.data != null) {
        var data = response.data!;
        if (data.status == true) {
          return data;
        } else {
          // Combine errors into a string if there are errors
          return ModelWilayah(status: false, data: data.data);
        }
      } else {
        return ModelWilayah(status: false);
      }
    } catch (e) {
      return ModelWilayah(status: false);
    }
  }

  Future<ModelWilayah> Kelurahan(Map<String, String>? body) async {
    try {
      var response = await t.apiCall<ModelWilayah>(
        urlbase,
        urlKelurahan,
        null,
        body,
        (json) => ModelWilayah.fromJson(json),
      );

      if (response.success && response.data != null) {
        var data = response.data!;
        if (data.status == true) {
          return data;
        } else {
          // Combine errors into a string if there are errors
          return ModelWilayah(status: false, data: data.data);
        }
      } else {
        return ModelWilayah(status: false);
      }
    } catch (e) {
      return ModelWilayah(status: false);
    }
  }
}
