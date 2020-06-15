class CourierTodo {
  List<Data> data;
  int status; // 200
  bool success; // true

  CourierTodo({this.data, this.status, this.success});

  factory CourierTodo.fromJson(Map<String, dynamic> json) {
    return CourierTodo(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => Data.fromJson(i)).toList()
          : null,
      status: json['status'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int count; // 2
  String officeName; // 水产加工厂-分类
  int okCount; // 0
  String phone; // 13792912041
  String username; // 陈福
  String address; // 陈福

  Data(
      {this.count,
      this.officeName,
      this.okCount,
      this.phone,
      this.username,
      this.address});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      count: json['count'],
      officeName: json['officeName'],
      okCount: json['okCount'],
      phone: json['phone'],
      username: json['username'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['officeName'] = this.officeName;
    data['okCount'] = this.okCount;
    data['phone'] = this.phone;
    data['username'] = this.username;
    data['address'] = this.address;
    return data;
  }
}
