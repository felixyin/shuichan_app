// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBean _$UserBeanFromJson(Map<String, dynamic> json) {
  return UserBean(
    data: json['data'] == null
        ? null
        : DataBean.fromJson(json['data'] as Map<String, dynamic>),
    success: json['success'] as bool,
    status: json['status'] as num,
  );
}

Map<String, dynamic> _$UserBeanToJson(UserBean instance) => <String, dynamic>{
      'data': instance.data,
      'success': instance.success,
      'status': instance.status,
    };

DataBean _$DataBeanFromJson(Map<String, dynamic> json) {
  return DataBean(
    id: json['id'] as String,
    company: json['company'] == null
        ? null
        : CompanyBean.fromJson(json['company'] as Map<String, dynamic>),
    office: json['office'] == null
        ? null
        : OfficeBean.fromJson(json['office'] as Map<String, dynamic>),
    loginName: json['loginName'] as String,
    password: json['password'] as String,
    no: json['no'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    mobile: json['mobile'] as String,
    loginIp: json['loginIp'] as String,
    loginDate: json['loginDate'] as String,
    loginFlag: json['loginFlag'] as String,
    photo: json['photo'] as String,
    oldLoginIp: json['oldLoginIp'] as String,
    oldLoginDate: json['oldLoginDate'] as String,
    roleNames: json['roleNames'] as String,
  );
}

Map<String, dynamic> _$DataBeanToJson(DataBean instance) => <String, dynamic>{
      'id': instance.id,
      'company': instance.company,
      'office': instance.office,
      'loginName': instance.loginName,
      'password': instance.password,
      'no': instance.no,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'mobile': instance.mobile,
      'loginIp': instance.loginIp,
      'loginDate': instance.loginDate,
      'loginFlag': instance.loginFlag,
      'photo': instance.photo,
      'oldLoginIp': instance.oldLoginIp,
      'oldLoginDate': instance.oldLoginDate,
      'roleNames': instance.roleNames,
    };

OfficeBean _$OfficeBeanFromJson(Map<String, dynamic> json) {
  return OfficeBean(
    id: json['id'] as String,
    sort: json['sort'] as num,
    hasChildren: json['hasChildren'] as bool,
    type: json['type'] as String,
    parentId: json['parentId'] as String,
  );
}

Map<String, dynamic> _$OfficeBeanToJson(OfficeBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sort': instance.sort,
      'hasChildren': instance.hasChildren,
      'type': instance.type,
      'parentId': instance.parentId,
    };

CompanyBean _$CompanyBeanFromJson(Map<String, dynamic> json) {
  return CompanyBean(
    id: json['id'] as String,
    name: json['name'] as String,
    sort: json['sort'] as num,
    hasChildren: json['hasChildren'] as bool,
    type: json['type'] as String,
    parentId: json['parentId'] as String,
  );
}

Map<String, dynamic> _$CompanyBeanToJson(CompanyBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sort': instance.sort,
      'hasChildren': instance.hasChildren,
      'type': instance.type,
      'parentId': instance.parentId,
    };
