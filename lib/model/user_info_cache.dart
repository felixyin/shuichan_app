/// @Author: 一凨
/// @Date: 2019-01-07 16:24:42
/// @Last Modified by: 一凨
/// @Last Modified time: 2019-01-08 17:37:42

import 'dart:async';
import 'dart:developer';

import 'package:shuichan_app/util/sql.dart';

abstract class UserInfoInterface {
  String get username;

  String get password;

  String get name;

  String get roleName;

  String get officeName;
}

class UserInfo implements UserInfoInterface {
  String username;
  String password;
  String name;
  String roleName;
  String officeName;

  UserInfo({
    this.username,
    this.password,
    this.name,
    this.officeName,
    this.roleName,
  });

  factory UserInfo.fromJSON(Map json) {
    return UserInfo(
      username: json['username'],
      password: json['password'].toString(),
      name: json['name'],
      officeName: json['officeName'],
      roleName: json['roleName'],
    );
  }

  Object toMap() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'officeName': officeName,
      'roleName': roleName,
    };
  }
}

class UserInfoControlModel {
  final String table = 'userInfo';
  Sql sql;

  UserInfoControlModel() {
    sql = Sql.setTable(table);
  }

  // 获取所有的收藏

  // 插入新的缓存
  Future insert(UserInfo userInfo) {
    var result = sql.insert({
      'username': userInfo.username,
      'password': userInfo.password,
      'name': userInfo.name,
      'officeName': userInfo.officeName,
      'roleName': userInfo.roleName,
    });
    return result;
  }

  // 获取用户信息
  Future<List<UserInfo>> getAllInfo() async {
    List list = await sql.getByCondition();
    List<UserInfo> resultList = [];
    list.forEach((item) {
      log('', error: item);
      resultList.add(UserInfo.fromJSON(item));
    });
    return resultList;
  }

  // 获取用户信息
  Future<UserInfo> getInfo() async {
    List list = await sql.getByCondition();
    return UserInfo.fromJSON(list[0]);
  }

  // 清空表中数据
  Future deleteAll() async {
    return await sql.deleteAll();
  }
}
