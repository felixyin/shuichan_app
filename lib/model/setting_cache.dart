/// @Author: 一凨
/// @Date: 2019-01-07 16:24:42
/// @Last Modified by: 一凨
/// @Last Modified time: 2019-01-08 17:37:42

import 'dart:async';

import 'package:shuichan_app/model/user_setting_bean.dart' as us;
import 'package:shuichan_app/util/sql.dart';

class SettingControlModel {
  final String table = 'setting';
  Sql sql;

  SettingControlModel() {
    sql = Sql.setTable(table);
  }

  // 插入新的设置
  Future insert(us.Body setting) {
    var result = sql.insert({
      'autoLogin': setting.autoLogin,
      'showToast': setting.showToast,
      'continueScan': setting.continueScan,
      'snakeScan': setting.snakeScan,
      'scanRefresh': setting.scanRefresh,
      'ownerHistory': setting.ownerHistory,
    });
    return result;
  }

/*
  // 获取用户信息
  Future<List<us.Body>> getAllSetting() async {
    List list = await sql.getByCondition();
    List<us.Body> resultList = [];
    list.forEach((item) {
      log('', error: item);
      resultList.add(us.Body.fromJson(item));
    });
    return resultList;
  }
*/

  // 获取用户信息
  Future<us.Body> getSetting() async {
    List list = await sql.getByCondition();
    if (null == list || list.isEmpty) return new us.Body();
    var data = list[0];
    return us.Body.fromJson(data);
  }

  // 清空表中数据
  Future deleteAll() async {
    return await sql.deleteAll();
  }
}
