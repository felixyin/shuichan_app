import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shuichan_app/widget/404.dart';

import './router_handler.dart';

class Routes {
  static String root = "/";
  static String home = "/home";
  static String widgetDemo = '/widget-demo';
  static String codeView = '/code-view';
  static String webViewPage = '/web-view-page';
  static String loginPage = '/loginpage';

//  static String settingPage = '/setting-page';
  static String my = "/my";

  static void configureRoutes(Router router) {
    // List widgetDemosList = new WidgetDemoList().getDemos();

    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new WidgetNotFound();
    });

    router.define(home, handler: homeHandler);

    router.define(my, handler: myHandler);

    // router.define('/category/:type', handler: categoryHandler);
    router.define('/category/error/404', handler: widgetNotFoundHandler);
    router.define(loginPage, handler: loginPageHandler);
    router.define(webViewPage, handler: webViewPageHand);
//    router.define(settingPage, handler: settingHandler);

    // widgetDemosList.forEach((demo) {
    //   Handler handler =
    //       new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    //     log('组件路由params=$params widgetsItem=${demo.routerName}');
    //     analytics.logEvent(name: 'component', parameters: {'name': demo.routerName});
    //     return demo.buildRouter(context);
    //   });
    //   router.define('${demo.routerName}', handler: handler);
    // });
  }
}
