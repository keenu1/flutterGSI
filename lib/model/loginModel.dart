class ModelLogin {
  bool? status;
  String? token;
  String? message;

  ModelLogin({
    this.status,
    this.token,
    this.message,
  });

  ModelLogin.fromJson(Map<String, dynamic> json) {
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
