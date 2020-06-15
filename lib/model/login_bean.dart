class LoginBean {
  Body body;
  String errorCode; // -1
  String msg; // 登录成功!
  bool success; // true

  LoginBean({this.body, this.errorCode, this.msg, this.success});

  factory LoginBean.fromJson(Map<String, dynamic> json) {
    return LoginBean(
      body: json['body'] != null ? Body.fromJson(json['body']) : null,
      errorCode: json['errorCode'],
      msg: json['msg'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['msg'] = this.msg;
    data['success'] = this.success;
    if (this.body != null) {
      data['body'] = this.body.toJson();
    }
    return data;
  }
}

class Body {
  String jSESSIONID; // eff2f0b4f9074e78a7f7f8b044c180e0
  bool mobileLogin; // true
  String name; // 测试快递员
  String officeName; // 宅急送
  String roleName; // 物流公司-快递员
  String username; // kd1

  Body(
      {this.jSESSIONID,
      this.mobileLogin,
      this.name,
      this.officeName,
      this.roleName,
      this.username});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      jSESSIONID: json['jSESSIONID'],
      mobileLogin: json['mobileLogin'],
      name: json['name'],
      officeName: json['officeName'],
      roleName: json['roleName'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jSESSIONID'] = this.jSESSIONID;
    data['mobileLogin'] = this.mobileLogin;
    data['name'] = this.name;
    data['officeName'] = this.officeName;
    data['roleName'] = this.roleName;
    data['username'] = this.username;
    return data;
  }
}
