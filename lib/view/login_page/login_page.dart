import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shuichan_app/model/setting_cache.dart';
import 'package:shuichan_app/model/user_info_cache.dart';
import 'package:shuichan_app/model/user_setting_bean.dart' as us;
import 'package:shuichan_app/util/data_utils.dart';
import 'package:shuichan_app/util/http/net_utils.dart';

import '../home.dart';

class LoginPage extends StatefulWidget {
  final bool isLogout;

  const LoginPage({Key key, this.isLogout}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState(isLogout);
}

class _LoginPageState extends State<LoginPage> {
  bool isLogout = false;

  // 利用FocusNode和_focusScopeNode来控制焦点 可以通过FocusNode.of(context)来获取widget树中默认的_focusScopeNode
  FocusNode _emailFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();
  FocusScopeNode _focusScopeNode = new FocusScopeNode();
  UserInfoControlModel _userInfoControlModel = new UserInfoControlModel();
  SettingControlModel _settingControlModel = new SettingControlModel();
  us.Body setting = new us.Body();

  GlobalKey<FormState> _signInFormKey = new GlobalKey();

  // TODO 发布生产版本之前，需要测试用的默认值给去掉
  TextEditingController _userNameEditingController =
      new TextEditingController(text: "");
  TextEditingController _passwordEditingController =
      new TextEditingController(text: "");

  bool isShowPassWord = false;
  String username = '';
  String password = '';
  bool isLoading = false;

  _LoginPageState(this.isLogout);

  @override
  void initState() {
    // 判断网络状态
    internetState();

    // 恢复用户上次录入的账号信息
    _userInfoControlModel.getAllInfo().then((list) {
      if (list.length > 0) {
        UserInfo _userInfo = list[0];
        log('获取的数据：${_userInfo.username} ${_userInfo.password}');
        setState(() {
          _userNameEditingController.text = _userInfo.username;
          _passwordEditingController.text = _userInfo.password;
          username = _userInfo.username;
          password = _userInfo.password;
        });

        // 自动登录
        _settingControlModel.getSetting().then((_setting) {
          this.setting = _setting;
          if (setting.autoLogin == 1) {
            if (!this.isLogout) {
              doLogin();
            }
          }
        });
      }
    }).catchError((onError) {
      log('error,读取用户本地存储的用户信息出错:', error: onError);
    });
    super.initState();
  }

  bool isInternet = true;

  /// 判断网络状态，并提示
  Future internetState() async {
//    Timer timer;
//    timer = Timer.periodic(const Duration(milliseconds: 1000 * 3), (Void) async {
//      log('>>>>>>>>>>>>>check net is ok?');
    try {
      final result = await InternetAddress.lookup('www.baidu.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isInternet = true;
          isLoading = false;
        });
//          if (null != timer) {
//            timer.cancel();
//            timer = null;
//          }
      }
    } on SocketException catch (_) {
      setState(() {
        isInternet = false;
      });
    }
//    });
  }

  // 登陆操作
  doLogin() {
    _signInFormKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    DataUtils.doLogin({'username': username, 'password': password})
        .then((result) {
      log('result----------------------->' + result.toString());
      setState(() {
        isLoading = false;
      });
      log('msg:' + result.msg);

      if (result.msg == '登录成功!') {
        if (!(result.body.roleName.contains("快递") ||
            result.body.roleName.contains("包装"))) {
          Fluttertoast.showToast(
              msg: '非包装人员、快递人员不允许登录',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0);
          return;
        }

        NetUtils.setJSESSIONID(result.body.jSESSIONID);
        if (setting.showToast == 1) {
          Fluttertoast.showToast(
              msg: result.msg,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        try {
          _userInfoControlModel.deleteAll().then((_result) {
            // log('删除结果：$result');
            _userInfoControlModel
                .insert(UserInfo(
              password: password,
              username: username,
              name: result.body.name,
              officeName: result.body.officeName,
              roleName: result.body.roleName,
            ))
                .then((value) {
              log('存储成功:$value');
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => AppPage(result.body.roleName),
                ),
                (route) => route == null,
              );
            });
          });
        } catch (err) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => AppPage(result.body.roleName)),
            (route) => route == null,
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: result.msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
        // 停留在登录界面
        // do nothing
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: '登录时报错，可能服务器出现问题，请联系管理员！报错信息是：${onError.toString()}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 30,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

// 创建登录界面的TextForm
  Widget buildSignInTextForm() {
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 190,
      //  * Flutter提供了一个Form widget，它可以对输入框进行分组，然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
      child: new Form(
        key: _signInFormKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: new TextFormField(
//                  keyboardType: TextInputType.phone,
                  controller: _userNameEditingController,
                  //关联焦点
                  focusNode: _emailFocusNode,
                  onEditingComplete: () {
                    if (_focusScopeNode == null) {
                      _focusScopeNode = FocusScope.of(context);
                    }
                    _emailFocusNode.unfocus();
                    _focusScopeNode.requestFocus(_passwordFocusNode);
                  },
//                  onFieldSubmitted: (v) {
//                    _emailFocusNode.unfocus();
//                  },
                  decoration: new InputDecoration(
                      icon: new Icon(
                        Icons.account_box,
                        color: Colors.black,
                      ),
                      hintText: "用户名",
                      border: InputBorder.none),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  //验证
                  validator: (value) => value.isEmpty ? "用户名不可为空!" : null,
                  onSaved: (value) => setState(() => username = value),
                ),
              ),
            ),
            new Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: new TextFormField(
                  controller: _passwordEditingController,
                  focusNode: _passwordFocusNode,
                  decoration: new InputDecoration(
                    icon: new Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    hintText: "密码",
                    border: InputBorder.none,
                    suffixIcon: new IconButton(
                      icon: new Icon(
                        Icons.remove_red_eye,
                        color: Colors.black,
                      ),
                      onPressed: showPassWord,
                    ),
                  ),
                  //输入密码，需要用*****显示
                  obscureText: !isShowPassWord,
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  onEditingComplete: () {
                    _passwordFocusNode.unfocus();
                  },
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "密码不可为空!" : null,
                  onSaved: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
              ),
            ),
            new Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignInButton() {
    return new InkWell(
      child: new Container(
        padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).primaryColor),
        child: new Text(
          "登    录",
          style: new TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      onTap: () {
        // 利用key来获取widget的状态FormState,可以用过FormState对Form的子孙FromField进行统一的操作
        if (_signInFormKey.currentState.validate()) {
          // 如果输入都检验通过，则进行登录操作
          // Scaffold.of(context)
          //     .showSnackBar(new SnackBar(content: new Text("执行登录操作")));
          //调用所有自孩子的save回调，保存表单内容
          doLogin();
        }
      },
    );
  }

// 点击控制密码是否显示
  void showPassWord() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  Widget buildLoading() {
    if (isLoading) {
      return Opacity(
        opacity: .8,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.black,
          ),
          child: SpinKitPouringHourglass(color: Colors.white),
        ),
      );
    }
    return Container();
  }

  Widget buildNetting() {
    if (!isInternet) {
      return Opacity(
        opacity: .8,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.black,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Text('您没有连接互联网'),
                Spacer(),
                Text('连接网络后再访问'),
                Spacer(),
              ],
            ),
          ),
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/paimaiLogo.png',
                  ),
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 35.0),
                      Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        width: 100.0,
                        height: 100.0,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Text(
                          '请登录',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      buildSignInTextForm(),
                      buildSignInButton(),
                      SizedBox(height: 35.0),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: buildLoading(),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: buildNetting(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
