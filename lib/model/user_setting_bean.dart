class UserSetting {
  Body body;
  int status; // 200
  bool success; // true

  UserSetting({this.body, this.status, this.success});

  factory UserSetting.fromJson(Map<String, dynamic> json) {
    return UserSetting(
      body: json['body'] != null ? Body.fromJson(json['body']) : null,
      status: json['status'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.body != null) {
      data['body'] = this.body.toJson();
    }
    return data;
  }
}

class Body {
  int autoLogin = 1; // 1
  int continueScan = 1; // 1
  int ownerHistory = 0; // 0
  int scanRefresh = 1; // 1
  int showToast = 0; // 0
  int snakeScan = 0; // 0

  Body(
      {this.autoLogin,
      this.continueScan,
      this.ownerHistory,
      this.scanRefresh,
      this.showToast,
      this.snakeScan});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      autoLogin: json['autoLogin'],
      continueScan: json['continueScan'],
      ownerHistory: json['ownerHistory'],
      scanRefresh: json['scanRefresh'],
      showToast: json['showToast'],
      snakeScan: json['snakeScan'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['autoLogin'] = this.autoLogin;
    data['continueScan'] = this.continueScan;
    data['ownerHistory'] = this.ownerHistory;
    data['scanRefresh'] = this.scanRefresh;
    data['showToast'] = this.showToast;
    data['snakeScan'] = this.snakeScan;
    return data;
  }
}
