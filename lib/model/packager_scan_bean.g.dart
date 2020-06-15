// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packager_scan_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackagerScanBean _$PackagerScanBeanFromJson(Map<String, dynamic> json) {
  return PackagerScanBean(
    success: json['success'] as bool,
    errorCode: json['errorCode'] as String,
    msg: json['msg'] as String,
    body: json['body'] == null
        ? null
        : BodyBean.fromJson(json['body'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PackagerScanBeanToJson(PackagerScanBean instance) =>
    <String, dynamic>{
      'success': instance.success,
      'errorCode': instance.errorCode,
      'msg': instance.msg,
      'body': instance.body,
    };

BodyBean _$BodyBeanFromJson(Map<String, dynamic> json) {
  return BodyBean(
    type: json['type'] as num,
    hint: json['hint'] as String,
    boxItemId: json['boxItemId'] as String,
  );
}

Map<String, dynamic> _$BodyBeanToJson(BodyBean instance) => <String, dynamic>{
      'type': instance.type,
      'hint': instance.hint,
      'boxItemId': instance.boxItemId,
    };
