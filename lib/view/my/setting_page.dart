import 'dart:developer';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shuichan_app/model/setting_cache.dart';
import 'package:shuichan_app/model/user_setting_bean.dart' as us;
import 'package:shuichan_app/router/application.dart';
import 'package:shuichan_app/router/routers.dart';
import 'package:shuichan_app/util/data_utils.dart';

class SettingPage extends StatefulWidget {
  @override
  _SwitchState createState() => _SwitchState();
}

bool switchValue = false;

class _SwitchState extends State<SettingPage> {
  // 设置对象
  us.Body setting = us.Body();

  SettingControlModel _settingControlModel = new SettingControlModel();

  @override
  void initState() {
    super.initState();

    DataUtils.getUserSetting().then((_setting) {
      log('-----ok----', error: _setting);
      setState(() {
        this.setting = _setting;
      });
    });
  }

  @override
  void dispose() {
    _settingControlModel = null;
    super.dispose();
  }

  void saveSetting() {
    DataUtils.saveUserSetting(this.setting).then((isOk) {
      if (setting.showToast == 1) {
        Fluttertoast.showToast(msg: "设置保存成功!");
      }
      // eventbus 传递参数，立即修改配置
      // 保存本地数据库，
      _settingControlModel.deleteAll().then((_result) {
        _settingControlModel.insert(this.setting).then((value) {
          log('存储成功:$value');
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("设置"),
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text('自动登录'),
              value: setting.autoLogin == 1,
              onChanged: (bool value) {
                setState(() {
                  setting.autoLogin = value ? 1 : 0;
                });
                saveSetting();
              },
            ),
            SwitchListTile(
              title: Text('显示除错误外的提示消息'),
              value: setting.showToast == 1,
              onChanged: (bool value) {
                setState(() {
                  setting.showToast = value ? 1 : 0;
                });
                saveSetting();
              },
            ),
            SwitchListTile(
              title: Text('连续扫码功能'),
              value: setting.continueScan == 1,
              onChanged: (bool value) {
                setState(() {
                  setting.continueScan = value ? 1 : 0;
                });
                saveSetting();
              },
            ),
            SwitchListTile(
              title: Text('摇一摇扫码功能'),
              value: setting.snakeScan == 1,
              onChanged: (bool value) {
                setState(() {
                  setting.snakeScan = value ? 1 : 0;
                });
                saveSetting();
              },
            ),
            SwitchListTile(
              title: Text('扫码成功后是否刷新列表'),
              value: setting.scanRefresh == 1,
              onChanged: (bool value) {
                setState(() {
                  setting.scanRefresh = value ? 1 : 0;
                });
                saveSetting();
              },
            ),
            SwitchListTile(
              title: Text('完成历史界面中仅显示自己扫码的记录'),
              value: setting.ownerHistory == 1,
              onChanged: (bool value) {
                setState(() {
                  setting.ownerHistory = value ? 1 : 0;
                });
                saveSetting();
              },
            ),
            ListTile(
              title: Text('修改设置需重新登录才可生效'),
              subtitle: Text('请退出后重新登录'),
              trailing: RaisedButton(
                onPressed: () {
                  DataUtils.logout().then((result) {
//                    Application.router.navigateTo(context, Routes.loginPage);
                    Application.router.navigateTo(
                      context,
                      Routes.loginPage,
                      clearStack: true,
                      transition: TransitionType.fadeIn,
                    );
                  });
                },
                child: Text('退出登录'),
              ),
            ),
          ],
        ));
  }
}
