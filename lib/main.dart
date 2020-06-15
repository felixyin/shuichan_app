import 'dart:core';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:shuichan_app/router/application.dart';
import 'package:shuichan_app/router/routers.dart';
import 'package:shuichan_app/util/data_utils.dart';
import 'package:shuichan_app/util/provider.dart';
import 'package:shuichan_app/util/shared_preferences.dart';
import 'package:shuichan_app/view/home.dart';
import 'package:shuichan_app/view/login_page/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'views/welcome_page/index.dart';
var sp;
var db;

class MyApp extends StatefulWidget {
  MyApp() {
    final router = new Router();

    Routes.configureRoutes(router);

    Application.router = router;
  }

  @override
  _MyAppState createState() => _MyAppState();
}

final int themeColor = Colors.blue.value;

class _MyAppState extends State<MyApp> {
  bool _hasLogin = true;
  bool _isLoading = false;

//  bool _isUpdate = false;

  @override
  void initState() {
    var platformAndroid =
        (Theme.of(context).platform == TargetPlatform.android);

    DataUtils.checkVersion({'appName': 'BakApp'}).then((version) async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      var localVersion = packageInfo.version;
      var netVersion = version.data.version;

      log("version---------------> local:$localVersion , net:$netVersion");
      bool b = netVersion.compareTo(localVersion) == 1;
      log("检查是否有最新版本，返回值：$b");
//      _isUpdate = b;
      if (b) {
        if (platformAndroid) {
          setState(() {});
          updateUrl(version.data.url);
//        } else {
//          setState(() {});
//          _UpdateURL();
        }
      }
    }).catchError((onError) {
      log('获取失败:$onError');
    });

    // todo 这个地方需要打开，并实现检查是否已经登录的接口
//    DataUtils.checkLogin().then((hasLogin) {
//      setState(() {
//        _hasLogin = hasLogin;
//        _isLoading = false;
//      });
//    }).catchError((onError) {
//      setState(() {
//        _hasLogin = false;
//        _isLoading = false;
//      });
//      log('身份信息验证失败:$onError');
//    });
    super.initState();
  }

  updateUrl(String currUrl) async {
    if (await canLaunch(currUrl)) {
      Fluttertoast.showToast(
          msg: '发现新版本，请用浏览器下载安装',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 15,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      await launch(currUrl);
    } else {
      throw '不能打开升级地址：$currUrl';
    }
  }

  showWelcomePage() {
    if (_isLoading) {
      return Container(
        color: Color(themeColor),
        child: Center(
          child: SpinKitPouringHourglass(color: Colors.white),
        ),
      );
    } else {
      // 判断是否已经登录
      // todo 同上todo，这个&&false，需要去掉，临时先都登录
      if (_hasLogin && false) {
        return AppPage('');
      } else {
        return LoginPage(
          isLogout: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'title',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: Color(themeColor),
        backgroundColor: Color(0xFFEFEFEF),
        accentColor: Color(0xFF888888),
        textTheme: TextTheme(
          //设置Material的默认字体样式
          bodyText2: TextStyle(color: Color(0xFF888888), fontSize: 16.0),
        ),
        iconTheme: IconThemeData(
          color: Color(themeColor),
          size: 35.0,
        ),
      ),
      home: new Scaffold(body: showWelcomePage()),
      onGenerateRoute: Application.router.generator,
      // navigatorObservers: <NavigatorObserver>[Analytics.observer],
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  TestWidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。
    // 写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  final provider = new Provider();
  await provider.init(true);
  sp = await SpUtil.getInstance();
  db = Provider.db;

  runApp(new MyApp());
}
