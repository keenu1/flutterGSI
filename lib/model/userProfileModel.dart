class UserProfileResponse {
  bool? status;
  String? message;
  UserProfileData? data;

  UserProfileResponse({this.status, this.message, this.data});

  UserProfileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UserProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['status'] = status;
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.toJson();
    }
    return result;
  }
}

class UserProfileData {
  User? user;
  Profile? profile;

  UserProfileData({this.user, this.profile});

  UserProfileData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    if (user != null) {
      result['user'] = user!.toJson();
    }
    if (profile != null) {
      result['profile'] = profile!.toJson();
    }
    return result;
  }
}

class User {
  int? id;
  String? username;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.username,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = json['emailVerifiedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'emailVerifiedAt': emailVerifiedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class Profile {
  int? id;
  int? userId;
  String? nik;
  String? nama;
  String? tempatLahir;
  String? tanggalLahir;
  String? jenisKelamin;
  String? golDarah;
  String? alamat;
  String? rt;
  String? rw;
  String? kel;
  String? desa;
  String? kecamatan;
  String? kabupaten;
  String? provinsi;
  String? agama;
  String? statusPekerjaan;
  String? statusPerkawinan;
  String? pekerjaan;
  String? kewarganegaraan;
  String? berlakuHingga;
  String? kodeBank;
  String? noRekening;
  String? accountName;
  String? createdAt;
  String? updatedAt;
  String? gambarKtp;

  Profile(
      {this.id,
      this.userId,
      this.nik,
      this.nama,
      this.tempatLahir,
      this.tanggalLahir,
      this.jenisKelamin,
      this.golDarah,
      this.alamat,
      this.rt,
      this.rw,
      this.kel,
      this.desa,
      this.kecamatan,
      this.kabupaten,
      this.provinsi,
      this.agama,
      this.statusPekerjaan,
      this.statusPerkawinan,
      this.pekerjaan,
      this.kewarganegaraan,
      this.berlakuHingga,
      this.kodeBank,
      this.noRekening,
      this.accountName,
      this.createdAt,
      this.updatedAt,
      this.gambarKtp});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    nik = json['nik'];
    nama = json['nama'];
    tempatLahir = json['tempatLahir'];
    tanggalLahir = json['tanggalLahir'];
    jenisKelamin = json['jenisKelamin'];
    golDarah = json['golDarah'];
    alamat = json['alamat'];
    rt = json['rt'];
    rw = json['rw'];
    kel = json['kel'];
    desa = json['desa'];
    kecamatan = json['kecamatan'];
    kabupaten = json['kabupaten'];
    provinsi = json['provinsi'];
    agama = json['agama'];
    statusPekerjaan = json['statusPekerjaan'];
    statusPerkawinan = json['statusPerkawinan'];
    pekerjaan = json['pekerjaan'];
    kewarganegaraan = json['kewarganegaraan'];
    berlakuHingga = json['berlakuHingga'];
    kodeBank = json['kodeBank'];
    noRekening = json['noRekening'];
    accountName = json['account_name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    gambarKtp = json['gambarKtp'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'nik': nik,
      'nama': nama,
      'tempatLahir': tempatLahir,
      'tanggalLahir': tanggalLahir,
      'jenisKelamin': jenisKelamin,
      'golDarah': golDarah,
      'alamat': alamat,
      'rt': rt,
      'rw': rw,
      'kel': kel,
      'desa': desa,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
      'agama': agama,
      'statusPekerjaan': statusPekerjaan,
      'statusPerkawinan': statusPerkawinan,
      'pekerjaan': pekerjaan,
      'kewarganegaraan': kewarganegaraan,
      'berlakuHingga': berlakuHingga,
      'kodeBank': kodeBank,
      'noRekening': noRekening,
      'account_name': accountName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'gambarKtp': gambarKtp,
    };
  }
}
