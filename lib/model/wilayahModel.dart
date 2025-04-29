class ModelWilayah {
  bool? status;
  List<DataWilayah>? data;

  ModelWilayah({
    this.status,
    this.data,
  });

  ModelWilayah.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DataWilayah>[];
      json['data'].forEach((v) {
        data!.add(DataWilayah.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataWilayah {
  String? id;
  String? nama;

  DataWilayah({
    this.id,
    this.nama,
  });

  DataWilayah.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    return data;
  }
}
