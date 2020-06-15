import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors/sensors.dart';
import 'package:shuichan_app/event/event_bus.dart';
import 'package:shuichan_app/event/event_model.dart';
import 'package:shuichan_app/model/setting_cache.dart';
import 'package:shuichan_app/model/user_info_cache.dart';
import 'package:shuichan_app/model/user_setting_bean.dart' as us;
import 'package:shuichan_app/util/data_utils.dart';
import 'package:shuichan_app/view/history/courier_history_page.dart';
import 'package:shuichan_app/view/history/packager_history_page.dart';
import 'package:shuichan_app/view/task/courier_task_page.dart';
import 'package:shuichan_app/view/task/packager_task_page.dart';

import 'my/my_page.dart';

class AppPage extends StatelessWidget {
  final int themeColor = Colors.blue.value;

  final String roleName;

  AppPage(this.roleName);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primaryColor: Color(themeColor),
        backgroundColor: Color(0xFFEFEFEF),
        accentColor: Colors.blue,
        focusColor: Colors.blue,
        textTheme: TextTheme(
          //设置Material的默认字体样式
          bodyText2: TextStyle(color: Color(0xFF888888), fontSize: 16.0),
        ),
        iconTheme: IconThemeData(
          color: Color(themeColor),
          size: 35.0,
        ),
      ),
      home: MyHomePage(title: '水产加工辅助', roleName: this.roleName),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  final String title;
  final String roleName;
  String oldTitle;

  MyHomePage({
    Key key,
    this.title,
    this.roleName,
  }) : super(key: key) {
    this.oldTitle = this.title;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Color _unClickColor = Colors.grey[600];

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SettingControlModel _settingControlModel = new SettingControlModel();
  us.Body setting = new us.Body();

  // 底部导航控制：今天任务、历史任务
//  PageController _pageController;
  List<Widget> pages = [];
  int _currentIndex = 0;
  Color jobBtnColor, msgBtnColor = _unClickColor;

  // 非wifi 网络提示问题
  String notWifiText;

  // 包装人员拍照的文件
//  File _image;

  // 摇一摇扫码控制
  int _counter = 0;

  StreamSubscription<ConnectivityResult> subscription;

  @override
  void dispose() {
    super.dispose();
    if (null != subscription) subscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    var self = this;

    // 用户设置
    _settingControlModel.getSetting().then((_setting) {
      setting = _setting;
      // 开启了摇一摇扫码
      if (setting.continueScan == 1) {
        accelerometerEvents.listen((AccelerometerEvent event) {
          // 摇一摇阀值,不同手机能达到的最大值不同，如某品牌手机只能达到20。
          int value = 20;
          if (event.x >= value ||
              event.x <= -value ||
              event.y >= value ||
              event.y <= -value ||
              event.z >= value ||
              event.z <= -value) {
//      if (event.z <= -value) {
            _incrementCounter();
            new Future.delayed(const Duration(milliseconds: 1200))
                .then((_) => self.clearCounter());
            if (_counter >= 20) {
              _scan();
            }
          }
        });
      }
    });

//    _pageController = PageController(initialPage: _currentIndex);
    String roleName = this.widget.roleName;
    if (null != roleName && '' != roleName) {
      if (roleName.contains("包装")) {
        pages = [PackagerTaskPage(), PackagerHistoryPage()];
        subscription = Connectivity()
            .onConnectivityChanged
            .listen((ConnectivityResult cr) {
          if (cr != ConnectivityResult.wifi) {
            setState(() {
              this.notWifiText = "  非WIFI";
            });
//            Fluttertoast.showToast(msg: "您没有连接wifi网络，上传图片耗流量！！！",
//            timeInSecForIos: 2);
          } else {
            setState(() {
              this.notWifiText = null;
            });
          }
        });
        log("登录角色--------------包装员角色》" + roleName);
      } else if (roleName.contains("快递")) {
        pages = [CourierTaskPage(), CourierHistoryPage()];
        log("登录角色--------------快递员角色》" + roleName);
      }
    } else {
      // fixme 下面代码貌似永远得不到执行，是否应该去掉，还是作为容错处理?
      pages = [PackagerTaskPage(), PackagerHistoryPage()];
      UserInfoControlModel().getInfo().then((userInfo) {
        if (userInfo.roleName.contains("包装")) {
          pages = [PackagerTaskPage(), PackagerHistoryPage()];
          log("登录角色--------------包装员角色》" + userInfo.roleName);
        } else if (userInfo.roleName.contains("快递")) {
          pages = [CourierTaskPage(), CourierHistoryPage()];
          log("登录角色--------------快递员角色》" + userInfo.roleName);
        }
      });
    }
  }

  void clearCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future pickPhoto(String boxItemId) async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    DataUtils.uploadPhoto(boxItemId, image).then((result) {
      if (setting.showToast == 1) {
        Fluttertoast.showToast(msg: result.msg);
      }
      // todo 需要刷新 任务列表
//      pages = [PackagerTaskPage(), PackagerHistoryPage()];
      // 开启扫码后刷新列表
      if (setting.scanRefresh == 1) {
        AppEventBus.singleton.fire(RefreshEvent());
      }
      // 开启了连续扫码模式
      if (setting.continueScan == 1) {
        _scan();
      }
    });
//    setState(() {
//      _image = image;
//    });
  }

  DateTime lastPopTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 点击返回键的操作
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          Fluttertoast.showToast(msg: '再按一次退出');
        } else {
          // 退出app
          lastPopTime = DateTime.now();
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Text(
            null == notWifiText ? "" : notWifiText,
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
          ),
          title: Text(widget.title),
          // backgroundColor: Colors.amber[500],
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.person),
                tooltip: '我',
                onPressed: () {
                  // do nothing
//                Application.router.navigateTo(context, Routes.my);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) {
                        return MyPage();
                      },
                    ),
                  );
                }),
          ],
        ),
        body: this.pages[_currentIndex],

        // floatingActionButton: FloatingActionButton(
        //   onPressed: clearCounter,
        //   tooltip: 'Increment2',
        //   child: Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
//        backgroundColor: Colors.pink,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              style: BorderStyle.none,
            ),
          ),
          child: Icon(Icons.settings_overscan),
          onPressed: _scan,
          isExtended: true,
        ),
//      bottomNavigationBar: BottomNavigationBar(
//        type: BottomNavigationBarType.fixed,
//        // BottomNavigationBarType 中定义的类型，有 fixed 和 shifting 两种类型
//        iconSize: 24.0,
//        // BottomNavigationBarItem 中 icon 的大小
//        currentIndex: _currentIndex,
//        // 当前所高亮的按钮index
//        onTap: _onItemTapped,
//        // 点击里面的按钮的回调函数，参数为当前点击的按钮 index
//        fixedColor: Colors.green,
//        // 如果 type 类型为 fixed，则通过 fixedColor 设置选中 item 的颜色
//        items: <BottomNavigationBarItem>[
//          BottomNavigationBarItem(
//            title: Text("微信"),
//            icon: Icon(ICons.HOME),
//            activeIcon: Icon(ICons.HOME_CHECKED),
//          ),
//          BottomNavigationBarItem(
//            title: Text(""),
//            icon: Icon(Icons.hourglass_empty),
////            activeIcon: Icon(ICons.ADDRESS_BOOK_CHECKED),
//          ),
////          BottomNavigationBarItem(
////            title: Text("通讯录"),
////            icon: Icon(ICons.ADDRESS_BOOK),
////            activeIcon: Icon(ICons.ADDRESS_BOOK_CHECKED),
////          ),
////          BottomNavigationBarItem(
////            title: Text("发现"),
////            icon: Icon(ICons.FOUND),
////            activeIcon: Icon(ICons.FOUND_CHECKED),
////          ),
//          BottomNavigationBarItem(
//            title: Text("我"),
//            icon: Icon(ICons.WO),
//            activeIcon: Icon(ICons.WO_CHECKED),
//          ),
//        ],
//      ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 15.0, // FloatingActionButton和BottomAppBar 之间的差距
          color: Colors.grey[200],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                focusColor: Colors.blue,
                colorBrightness: Brightness.light,
                hoverColor: Colors.red,
                highlightColor: Colors.blue,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.today,
                      color: jobBtnColor,
                    ),
                    Text(
                      '今天任务',
                      style: TextStyle(
                        color: jobBtnColor,
                      ),
                    )
                  ],
                ),
                onPressed: _jobClick,
              ),
              MaterialButton(
                focusColor: Colors.blue,
                colorBrightness: Brightness.light,
                hoverColor: Colors.red,
                highlightColor: Colors.blue,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.history,
                      color: msgBtnColor,
                    ),
                    Text(
                      '完成历史',
                      style: TextStyle(
                        color: msgBtnColor,
                      ),
                    ),
                  ],
                ),
                onPressed: _msgClick,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _scan() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      // 发起网络请求，执行扫码服务端处理
      DataUtils.scanQrCode(barcode.rawContent).then((result) {
        final type = result.type;
        final hint = result.hint;
        if (type == 3) {
          // 已经上传过图片了，后续增加或者覆盖，现在是覆盖
          final boxItemId = result.boxItemId;
          showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('提示'),
                  content: Text(hint),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('取消'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('确定'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              }).then((isOk) {
            log('用户点击了确定吗？', name: 'info', error: isOk);
            if (isOk) {
              pickPhoto(boxItemId);
            }
          });
        } else if (type == 2) {
          // 第一次包装人员扫码，需要拍照上传图片
          final boxItemId = result.boxItemId;
          if (setting.showToast == 1) {
            Fluttertoast.showToast(msg: hint);
          }
          pickPhoto(boxItemId);
        } else if (type == 1) {
          // 包装扫码失败消息提示
          Fluttertoast.showToast(
              msg: result.hint,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0);
          // 停留在登录界面
          // do nothing
        } else if (type == 11 || type == 12) {
          // 11 快递人员扫码，发现未包装完毕，不允许扫码
          // 12 被其他快递员、快递公司扫码了
          Fluttertoast.showToast(
              msg: result.hint,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (type == 13) {
          if (setting.showToast == 1) {
            Fluttertoast.showToast(msg: hint);
          }
          if (setting.scanRefresh == 1) {
            AppEventBus.singleton.fire(RefreshEvent());
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        Fluttertoast.showToast(msg: '您需要开启访问摄像头权限');
      } else {
        Fluttertoast.showToast(msg: '发生未知异常，请联系管理员！');
      }
    } on FormatException {
      Fluttertoast.showToast(msg: '您取消了扫码');
    } catch (e) {
      Fluttertoast.showToast(msg: '发生未知异常，请联系管理员！');
    }
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
//        _pageController.animateToPage(index,
//        duration: Duration(milliseconds: 1), curve: Curves.bounceIn);
      });
    }
  }

  void _jobClick() {
    setState(() {
      this.jobBtnColor = Colors.black;
      this.msgBtnColor = _unClickColor;
    });
    _onItemTapped(0);
  }

  void _msgClick() {
    setState(() {
      this.msgBtnColor = Colors.black;
      this.jobBtnColor = _unClickColor;
    });
    _onItemTapped(1);
  }
}
