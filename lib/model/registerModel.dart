class ModelRegister {
  bool? status;
  String? token;
  String? message;

  ModelRegister({
    this.status,
    this.token,
    this.message,
  });

  ModelRegister.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    data['message'] = message;

    return data;
  }
}
