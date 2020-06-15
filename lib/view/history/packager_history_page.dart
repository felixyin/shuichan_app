import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shuichan_app/event/event_bus.dart';
import 'package:shuichan_app/event/event_model.dart';
import 'package:shuichan_app/model/packager_todo_bean.dart' as PackagerTodo;
import 'package:shuichan_app/model/setting_cache.dart';
import 'package:shuichan_app/model/user_setting_bean.dart' as us;
import 'package:shuichan_app/util/data_utils.dart';
import 'package:shuichan_app/view/timeline/date_picker_timeline.dart';

class PackagerHistoryPage extends StatefulWidget {
  PackagerHistoryPage({Key key}) : super(key: key);

  @override
  _PackagerHistoryPageState createState() => _PackagerHistoryPageState();
}

class _PackagerHistoryPageState extends State<PackagerHistoryPage> {
  //列表要展示的数据
  List<PackagerTodo.DataBean> list = new List<PackagerTodo.DataBean>();
  SettingControlModel _settingControlModel = new SettingControlModel();
  us.Body setting = new us.Body();

  @override
  void initState() {
    super.initState();
    // 用户设置
    _settingControlModel.getSetting().then((_setting) {
      setting = _setting;
    });
    initDataList();
    AppEventBus.singleton.on<RefreshEvent>().listen((event) {
      log('refresh>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      initDataList();
    });
  }

  Future<void> initDataList() async {
    await DataUtils.findPackagerHistoryList(selectDate.toString())
        .then((List<PackagerTodo.DataBean> _list) {
      setState(() {
        list = _list;
      });
    });
    return Future.value(null);
  }

  Widget _renderRow(BuildContext context, int index) {
    var d = list[index];
    var children2 = <Widget>[
      Text('重量:'),
      Text(
        '${d.weight}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(', 数量:'),
      Text(
        '${d.count}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ];
    if (d.okCount != 0) {
      children2.addAll(<Widget>[
        Text(', 已包装:'),
        Text(
          '${d.okCount}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ]);
    }
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundColor:
                d.okCount < d.count ? Colors.green[400] : Colors.amber[400],
            foregroundColor: Colors.white,
            child: Text('${index + 1}'),
          ),
          title: Text(
            d.spec,
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('客户:'),
                  Text(
                    '${d.username}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('地址:'),
                  Text(
                    '${d.address}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: children2,
              ),
            ],
          ),
//          trailing: Icon(
//            Icons.keyboard_arrow_right,
//            color: Colors.blue[200],
//          ),
//          onTap: showDetail,
        ),
        Divider(
          height: 0.2,
        ),
      ],
    );
  }

  void showDetail() {
    log('显示详情');
  }

  DateTime _lastPressedAdt; //上次点击时间 初始化的时候是空，下面会做判断
//  DateTime _currentSelection = new DateTime.now().add(Duration(days: -1));
  DateTime selectDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        if (_lastPressedAdt == null ||
            DateTime.now().difference(_lastPressedAdt) > Duration(seconds: 5)) {
          //两次点击时间间隔超过1秒则重新计时
          _lastPressedAdt = DateTime.now();
          if (setting.showToast == 1) {
            Fluttertoast.showToast(msg: '数据已刷新');
          }
          return initDataList();
        }
        return Future.value(null);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DatePickerTimeline(
            selectDate,
            height: 85,
            onDateChange: (date) {
              String dateStr = '${date.year}-${date.month}-${date.day}';
              DataUtils.findPackagerHistoryList(date.toString())
                  .then((List<PackagerTodo.DataBean> _list) {
                if (setting.showToast == 1) {
                  Fluttertoast.showToast(msg: '已经加载$dateStr数据');
                }
                setState(() {
                  list = _list;
                  selectDate = date;
                });
              });
            },
          ),
          child()
        ],
      ),
    );
  }

  Widget child() {
    return Expanded(
      child: list.length > 0
          ? ListView.builder(
              itemBuilder: _renderRow,
              itemCount: list.length,
            )
          : Center(
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(50, 100, 50, 100),
                  child: Text('没有数据'),
                ),
                onTap: () {
                  if (_lastPressedAdt == null ||
                      DateTime.now().difference(_lastPressedAdt) >
                          Duration(seconds: 3)) {
                    //两次点击时间间隔超过1秒则重新计时
                    _lastPressedAdt = DateTime.now();
                    initDataList();
                  }
                  if (setting.showToast == 1) {
                    Fluttertoast.showToast(msg: '数据已最新');
                  }
                },
              ),
            ),
    );
  }
}
