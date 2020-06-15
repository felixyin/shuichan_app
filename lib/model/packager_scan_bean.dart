import 'package:json_annotation/json_annotation.dart';

part 'packager_scan_bean.g.dart';

@JsonSerializable()
class PackagerScanBean {
  bool success;
  String errorCode;
  String msg;
  BodyBean body;

  PackagerScanBean({this.success, this.errorCode, this.msg, this.body});

  factory PackagerScanBean.fromJson(Map<String, dynamic> json) =>
      _$PackagerScanBeanFromJson(json);

  Map<String, dynamic> toJson() => _$PackagerScanBeanToJson(this);
}

@JsonSerializable()
class BodyBean {
  num type;
  String hint;
  String boxItemId;

  BodyBean({this.type, this.hint, this.boxItemId});

  factory BodyBean.fromJson(Map<String, dynamic> json) =>
      _$BodyBeanFromJson(json);

  Map<String, dynamic> toJson() => _$BodyBeanToJson(this);
}
