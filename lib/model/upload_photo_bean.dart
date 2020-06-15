import 'package:json_annotation/json_annotation.dart';

part 'upload_photo_bean.g.dart';

@JsonSerializable()
class UploadPhotoBean {
  bool success;
  String errorCode;
  String msg;

  UploadPhotoBean({this.success, this.errorCode, this.msg});

  factory UploadPhotoBean.fromJson(Map<String, dynamic> json) =>
      _$UploadPhotoBeanFromJson(json);

  Map<String, dynamic> toJson() => _$UploadPhotoBeanToJson(this);
}
