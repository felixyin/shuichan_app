// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_photo_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadPhotoBean _$UploadPhotoBeanFromJson(Map<String, dynamic> json) {
  return UploadPhotoBean(
    success: json['success'] as bool,
    errorCode: json['errorCode'] as String,
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$UploadPhotoBeanToJson(UploadPhotoBean instance) =>
    <String, dynamic>{
      'success': instance.success,
      'errorCode': instance.errorCode,
      'msg': instance.msg,
    };
