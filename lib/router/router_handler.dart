import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shuichan_app/view/home.dart';
import 'package:shuichan_app/view/login_page/login_page.dart';
import 'package:shuichan_app/view/my/my_page.dart';
import 'package:shuichan_app/view/web_page/web_view_page.dart';
import 'package:shuichan_app/widget/404.dart';

// app的首页
var homeHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new AppPage('');
  },
);

// app的用户页
var myHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new MyPage();
  },
);

var widgetNotFoundHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new WidgetNotFound();
});

var loginPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage(isLogout: true);
});

var webViewPageHand = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String title = params['title']?.first;
  String url = params['url']?.first;
  return new WebViewPage(url, title);
});
