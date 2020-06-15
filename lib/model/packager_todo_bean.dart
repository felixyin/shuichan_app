import 'package:json_annotation/json_annotation.dart';

part 'packager_todo_bean.g.dart';

@JsonSerializable()
class PackagerTodoBean {
  List<DataBean> data;
  bool success;
  num status;

  PackagerTodoBean({this.data, this.success, this.status});

  factory PackagerTodoBean.fromJson(Map<String, dynamic> json) =>
      _$PackagerTodoBeanFromJson(json);

  Map<String, dynamic> toJson() => _$PackagerTodoBeanToJson(this);
}

@JsonSerializable()
class DataBean {
  String no;
  num count;
  num weight;
  num okCount;
  String spec;
  String agentName;
  String username;
  String phone;
  String address;
  num boxId;

  DataBean(
      {this.no,
      this.count,
      this.weight,
      this.okCount,
      this.spec,
      this.agentName,
      this.username,
      this.phone,
      this.address,
      this.boxId});

  factory DataBean.fromJson(Map<String, dynamic> json) =>
      _$DataBeanFromJson(json);

  Map<String, dynamic> toJson() => _$DataBeanToJson(this);
}
