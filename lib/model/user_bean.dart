import 'package:json_annotation/json_annotation.dart';

part 'user_bean.g.dart';

@JsonSerializable()
class UserBean {
  DataBean data;
  bool success;
  num status;

  UserBean({this.data, this.success, this.status});

  factory UserBean.fromJson(Map<String, dynamic> json) =>
      _$UserBeanFromJson(json);

  Map<String, dynamic> toJson() => _$UserBeanToJson(this);
}

@JsonSerializable()
class DataBean {
  String id;
  CompanyBean company;
  OfficeBean office;
  String loginName;
  String password;
  String no;
  String name;
  String email;
  String phone;
  String mobile;
  String loginIp;
  String loginDate;
  String loginFlag;
  String photo;
  String oldLoginIp;
  String oldLoginDate;
  String roleNames;

  DataBean(
      {this.id,
      this.company,
      this.office,
      this.loginName,
      this.password,
      this.no,
      this.name,
      this.email,
      this.phone,
      this.mobile,
      this.loginIp,
      this.loginDate,
      this.loginFlag,
      this.photo,
      this.oldLoginIp,
      this.oldLoginDate,
      this.roleNames});

  factory DataBean.fromJson(Map<String, dynamic> json) =>
      _$DataBeanFromJson(json);

  Map<String, dynamic> toJson() => _$DataBeanToJson(this);
}

@JsonSerializable()
class OfficeBean {
  String id;
  num sort;
  bool hasChildren;
  String type;
  String parentId;

  OfficeBean({this.id, this.sort, this.hasChildren, this.type, this.parentId});

  factory OfficeBean.fromJson(Map<String, dynamic> json) =>
      _$OfficeBeanFromJson(json);

  Map<String, dynamic> toJson() => _$OfficeBeanToJson(this);
}

@JsonSerializable()
class CompanyBean {
  String id;
  String name;
  num sort;
  bool hasChildren;
  String type;
  String parentId;

  CompanyBean(
      {this.id,
      this.name,
      this.sort,
      this.hasChildren,
      this.type,
      this.parentId});

  factory CompanyBean.fromJson(Map<String, dynamic> json) =>
      _$CompanyBeanFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyBeanToJson(this);
}
