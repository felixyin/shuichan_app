import 'dart:developer';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shuichan_app/model/user_bean.dart' as User;
import 'package:shuichan_app/router/application.dart';
import 'package:shuichan_app/router/routers.dart';
import 'package:shuichan_app/util/data_utils.dart';
import 'package:shuichan_app/view/my/my_info_page.dart';
import 'package:shuichan_app/view/my/setting_page.dart';
import 'package:shuichan_app/view/my/style.dart';
import 'package:shuichan_app/view/my/user_info_widget.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
      ),
      body: _MyPage(),
    );
  }
}

class _MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<_MyPage> {
  User.DataBean userBean = new User.DataBean();
  bool isUserInfoLoaded = false;

  @override
  void initState() {
    super.initState();
    DataUtils.getUserInfo().then((result) {
      setState(() {
        this.userBean = result.data;
        this.isUserInfoLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 头像组件
    Widget userImage = new UserIconWidget(
      padding: const EdgeInsets.only(top: 28.0, right: 18.0, left: 25.0),
      width: 55.0,
      height: 55.0,
      image: userBean.photo,
      isNetwork: true,
      onPressed: () {
//         NavigatorUtils.goPerson(context, eventViewModel.actionUser);
      },
    );

    Widget buildRow(icon, title, isEnd, onTap) {
      var row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new UserIconWidget(
            padding: const EdgeInsets.only(top: 0.0, right: 14.0, left: 14.0),
            width: 32.0,
            height: 32.0,
            image: icon,
            isNetwork: false,
            onPressed: () {
              // NavigatorUtils.goPerson(context, eventViewModel.actionUser);
            },
          ),
          Expanded(
            child: Container(
              decoration: !isEnd
                  ? BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(
                            0xffd9d9d9,
                          ),
                          width: .5,
                        ),
                      ),
                    )
                  : null,
              padding: EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15.0, right: 10.0),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.grey[500],
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
      if (onTap != null) {
        return InkWell(child: row, onTap: onTap);
      }
      return row;
    }

    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container(
              height: 130.0,
              child: RawMaterialButton(
                onPressed: () {
                  if (this.userBean == null) {
                    Fluttertoast.showToast(
                        msg: '您未联网，请先联网！',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (c) {
                        return new MyInfoPage(this.userBean);
                      },
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    userImage,
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 53.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${userBean.name != null ? userBean.name : ''}',
                              style: TextStyle(
                                fontSize: 22.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              height: 2.0,
                            ),
                            Text(
                              userBean.company != null
                                  ? '公司：${userBean.company.name}'
                                  : '公司：',
                              maxLines: 1,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13.0),
                            )
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              top: 45.0, bottom: 15.0, right: 10.0),
                          child: Icon(
                            ICons.QR,
                            color: Colors.grey,
                            size: 15.0,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: 45.0, bottom: 15.0, right: 10.0),
                          child: Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            /* Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  color: Color(0xffEDEDED),
                  height: 10.0,
                ),
                InkWell(
                  child: buildRow('assets/images/me_pay.png', '支付', true, null),
                  onTap: () {
                    Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text('Tap'),
                    ));
                  },
                ),
              ],
            ),*/
            /*  Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    color: Color(0xffEDEDED),
                    height: 10.0,
                  ),
                  buildRow('assets/images/me_college.png', '收藏', false, null),
                  buildRow('assets/images/me_gallary.png', '相册', false, null),
                  buildRow('assets/images/me_wallet.png', '卡包', false, null),
                  buildRow('assets/images/me_face.png', '表情', true, null),
                ],
              ),
            ),*/
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  color: Color(0xffEDEDED),
                  height: 10.0,
                ),
                buildRow('assets/images/setting.png', '设置', true, () {
//                  Application.router.navigateTo(
//                    context,
//                    Routes.settingPage,
//                    transition: TransitionType.inFromRight,
//                  );
                  if (this.isUserInfoLoaded) {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (c) {
                          return new SettingPage();
                        },
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: '请等待用户信息加载完毕！',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                }),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  color: Color(0xffEDEDED),
                  height: 10.0,
                ),
                buildRow('assets/images/logout.png', '退出登录', true, () {
                  log("sdkflj");
                  DataUtils.logout().then((result) {
//                    Application.router.navigateTo(context, Routes.loginPage);
                    Application.router.navigateTo(
                      context,
                      Routes.loginPage,
                      clearStack: true,
                      transition: TransitionType.fadeIn,
                    );
                  });
                }),
              ],
            ),
          ],
        )
      ],
    );
  }
}
