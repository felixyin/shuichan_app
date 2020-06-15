import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shuichan_app/event/event_bus.dart';
import 'package:shuichan_app/event/event_model.dart';
import 'package:shuichan_app/model/courier_todo_bean.dart' as ct;
import 'package:shuichan_app/model/factory_bean.dart' as f;
import 'package:shuichan_app/model/setting_cache.dart';
import 'package:shuichan_app/model/user_setting_bean.dart' as us;
import 'package:shuichan_app/util/data_utils.dart';
import 'package:shuichan_app/view/autocomplete/autocomplete_textfield.dart';

class CourierTaskPage extends StatefulWidget {
  CourierTaskPage({Key key}) : super(key: key);

  @override
  _CourierTaskPageState createState() => _CourierTaskPageState();
}

class _CourierTaskPageState extends State<CourierTaskPage> {
  SettingControlModel _settingControlModel = new SettingControlModel();
  us.Body setting = new us.Body();

  //列表要展示的数据
  List<ct.Data> list = new List<ct.Data>();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  String currentText = "";
  TextEditingController textEditingController = TextEditingController(text: "");
  List<String> suggestions = [];
  List<f.Data> suggestionsData = [];
  String _officeName = "";

  @override
  void initState() {
    super.initState();
    // 用户设置
    _settingControlModel.getSetting().then((_setting) {
      setting = _setting;
    });
    initListData();
    initFactoryList();
    AppEventBus.singleton.on<RefreshEvent>().listen((event) {
      log('refresh>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      initListData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  Future<void> initListData() async {
    String factoryId;
    suggestionsData.forEach((d) {
      if (d.name == currentText) {
        factoryId = d.id;
      }
    });

    await DataUtils.findCourierTodoList(factoryId).then((List<ct.Data> _list) {
      setState(() => list = _list);
    });
    return Future.value(null);
  }

  Future<void> initFactoryList() async {
    await DataUtils.findAllOffice().then((List<f.Data> _list) {
      suggestionsData = _list;
      setState(() {
        suggestions = _list.map((t) => t.name).toList();
      });
    });
    return Future.value(null);
  }

  Widget _renderRow(BuildContext context, int index) {
    var d = list[index];
    var children2 = <Widget>[
//      Text(
//        '规格：${d.spec}',
//      ),
      Text(
        '姓名：${d.username}',
      ),
      Text(
        '地址：${d.address}',
      )
//      Text(
//        '电话：${d.phone}',
//      ),
    ];

    var children3 = <Widget>[];
    if (d.officeName != _officeName) {
      children3.add(Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              d.officeName,
              style: TextStyle(fontSize: 22),
            )
          ],
        ),
      ));
      children3.add(Divider(
        height: 0.2,
      ));
      _officeName = d.officeName;
    }
    if (d.username == "-1" && d.phone == "-1") {
      children3.addAll(<Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            child: Text('${index + 1}'),
          ),
          title: Row(
            children: <Widget>[
              Text(
                '总计箱数：${d.count}',
                style: TextStyle(fontSize: 18),
              ),
              Spacer(),
              d.okCount != 0
                  ? Text(
                      '已取：${d.okCount}',
                      style: TextStyle(fontSize: 18),
                    )
                  : Text(''),
              Text(''),
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
      ]);
    } else {
      children3.addAll(<Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundColor:
                d.okCount > 0 ? Colors.green[400] : Colors.blue[400],
            foregroundColor: Colors.white,
            child: Text('${index + 1}'),
          ),
          title: Row(
            children: <Widget>[
              Text(
                '箱数：${d.count}',
                style: TextStyle(fontSize: 18),
              ),
              Spacer(),
              d.okCount != 0
                  ? Text(
                      '已取：${d.okCount}',
                      style: TextStyle(fontSize: 18),
                    )
                  : Text(''),
              Text(''),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children2,
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
      ]);
    }

    if (index == list.length - 1) {
      children3.add(Text(''));
      children3.add(Text(''));
    }
    return Column(
      children: children3,
    );
  }

  void showDetail() {
    log('显示详情');
  }

  DateTime _lastPressedAdt; //上次点击时间 初始化的时候是空，下面会做判断

  @override
  Widget build(BuildContext context) {
    _officeName = ""; // 每次重绘前需要重置

    return Column(
      children: <Widget>[
        Stack(
//          overflow: Overflow.clip,
          alignment: Alignment.center,
          fit: StackFit.loose, //未定位widget占满Stack整个空间
          children: <Widget>[
            suggestions.isNotEmpty
                ? SimpleAutoCompleteTextField(
                    key: key,
                    minLength: 0,
                    suggestions: suggestions,
                    decoration: InputDecoration(hintText: "请输入工厂拼音首字母过滤"),
                    controller: textEditingController,
                    textChanged: (text) => currentText = text,
                    clearOnSubmit: false,
                    textSubmitted: (text) {
                      currentText = text;
                      // 发送网络请求
                      initListData();
                    },
                  )
                : Center(child: Text('正在加载加工厂 ')),
            /*Positioned(
              right: 0.0,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.check_box,
                  color: Colors.black38,
                ),
                onPressed: () {
                  log('press');
                },
              ),
            )*/
          ],
        ),
        Expanded(
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
                        initListData();
                      }
                      if (setting.showToast == 1) {
                        Fluttertoast.showToast(msg: '数据已最新');
                      }
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
