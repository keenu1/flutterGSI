import 'package:flutter_dotenv/flutter_dotenv.dart';

var urlbase = dotenv.env['BASE_URL'] ?? '';
const String urlLogin = "login";
const String urlRegister = "register";
const String urlProvinsi = "wilayah/provinsi";
const String urlKabupaten = "wilayah/kabupaten";
const String urlKecamatan = "wilayah/kecamatan";
const String urlKelurahan = "wilayah/kelurahan";
const String urlProfileUpdate = "update-profile";
const String urlProfileGet = "get-profile";
