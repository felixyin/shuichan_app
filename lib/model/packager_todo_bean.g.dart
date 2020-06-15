// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packager_todo_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackagerTodoBean _$PackagerTodoBeanFromJson(Map<String, dynamic> json) {
  return PackagerTodoBean(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : DataBean.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    success: json['success'] as bool,
    status: json['status'] as num,
  );
}

Map<String, dynamic> _$PackagerTodoBeanToJson(PackagerTodoBean instance) =>
    <String, dynamic>{
      'data': instance.data,
      'success': instance.success,
      'status': instance.status,
    };

DataBean _$DataBeanFromJson(Map<String, dynamic> json) {
  return DataBean(
    no: json['no'] as String,
    count: json['count'] as num,
    weight: json['weight'] as num,
    okCount: json['okCount'] as num,
    spec: json['spec'] as String,
    agentName: json['agentName'] as String,
    username: json['username'] as String,
    phone: json['phone'] as String,
    address: json['address'] as String,
    boxId: json['boxId'] as num,
  );
}

Map<String, dynamic> _$DataBeanToJson(DataBean instance) => <String, dynamic>{
      'no': instance.no,
      'count': instance.count,
      'weight': instance.weight,
      'okCount': instance.okCount,
      'spec': instance.spec,
      'agentName': instance.agentName,
      'username': instance.username,
      'phone': instance.phone,
      'address': instance.address,
      'boxId': instance.boxId,
    };
