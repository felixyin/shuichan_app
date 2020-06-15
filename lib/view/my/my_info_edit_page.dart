import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shuichan_app/model/user_bean.dart' as User;
import 'package:shuichan_app/router/application.dart';
import 'package:shuichan_app/router/routers.dart';
import 'package:shuichan_app/util/data_utils.dart';

// ignore: must_be_immutable
class MyInfoEditPage extends StatefulWidget {
  final User.DataBean userBean;
  bool isSubmitting = false;

  MyInfoEditPage(this.userBean, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyInfoEditPageState(this.userBean);
}

class _MyInfoEditPageState extends State<MyInfoEditPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();

  User.DataBean userBean;

  _MyInfoEditPageState(User.DataBean userBean) {
    userBean.password = '';
    this.userBean = userBean;
  }

  String _validateName(String value) {
    if (null == value || value.isEmpty) return '姓名不能为空';
    final RegExp nameExp = new RegExp(r'^[\u2E80-\u9FFF]+$');
    if (!nameExp.hasMatch(value)) return '姓名必须为汉子';
    return null;
  }

  String _validateMobile(String value) {
    if (null == value || value.isEmpty) return '手机号不能为空';
    final RegExp nameExp = new RegExp(r'^[1]([3-9])[0-9]{9}$');
    if (!nameExp.hasMatch(value)) return '请填写手机号';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('修改个人信息'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 24.0),
              // "Name" form.
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.person),
                  hintText: '请填写真实姓名',
                  labelText: '姓名 *',
                ),
                initialValue: this.userBean.name,
                onSaved: (String value) {
                  this.userBean.name = value;
                },
                validator: _validateName,
              ),
              SizedBox(height: 24.0),
              // "Phone number" form.
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.phone),
                  hintText: '请填写正在使用的手机号',
                  labelText: '手机号 *',
                  prefixText: '',
                ),
                keyboardType: TextInputType.phone,
                initialValue: this.userBean.mobile,
                onSaved: (String value) {
                  this.userBean.mobile = value;
                },
                validator: _validateMobile,
                // TextInputFormatters are applied in sequence.
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
              ),
              SizedBox(height: 24.0),
              // "Email" form.
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.person_outline),
                  hintText: '请填写英文加数字格式的登录账号',
                  labelText: '登录账号',
                ),
                keyboardType: TextInputType.text,
                initialValue: this.userBean.loginName,
                onSaved: (String value) {
                  this.userBean.loginName = value;
                },
              ),
              SizedBox(height: 24.0),
              // "Password" form.
              PasswordField(
                fieldKey: _passwordFieldKey,
                helperText: '密码请至少输入8位字符或数字',
                labelText: '新密码(留空则不会被修改) *',
                initialValue: this.userBean.password,
                onFieldSubmitted: (String value) {
                  setState(() {
                    this.userBean.password = value;
                  });
                },
              ),
              SizedBox(height: 24.0),
              // "Re-type password" form.
              TextFormField(
                enabled: this.userBean.password != null &&
                    this.userBean.password.isNotEmpty,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.threesixty),
                  labelText: '请再次输入新密码',
                ),
                maxLength: 8,
                obscureText: true,
                validator: (String value) {
                  if (value != this.userBean.password) {
                    return '两次输入的新密码不同';
                  }
                  return null;
                },
              ),
              MaterialButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.save,
                      color: Colors.blue,
                    ),
                    Text(
                      ' 保 存 ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                onPressed: _onSaveBtnTap,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onSaveBtnTap() {
    if (!this.widget.isSubmitting) {
      this.widget.isSubmitting = true;
      final FormState form = _formKey.currentState;
      if (form.validate()) {
        form.save();
//      final json = this.userBean.toJson();
//      log(json);

        DataUtils.saveUserInfo(this.userBean).then((result) async {
          if (result == 1) {
            // 没有修改密码
            Fluttertoast.showToast(msg: '保存成功');
            Future.delayed(Duration(seconds: 1), () {
              Navigator.of(context).pop();
              this.widget.isSubmitting = false;
            });
          } else if (result == 2) {
            // 修改密码了，则需要退出登录后，重新登录
            Fluttertoast.showToast(msg: '保存成功，请重新登录！');
            Future.delayed(Duration(seconds: 1), () {
//              Navigator.of(context).popUntil(ModalRoute.withName(Routes.home));
              Application.router.navigateTo(context, Routes.loginPage);
//              Navigator.of(context).pushNamedAndRemoveUntil(Routes.loginPage,
//              ModalRoute.withName(Routes.loginPage));
              this.widget.isSubmitting = false;
            });
          } else {
            Fluttertoast.showToast(msg: '保存失败');
            this.widget.isSubmitting = false;
          }
        }).catchError((err) {
          log('error:修改用户信息发生错误', error: err);
          Fluttertoast.showToast(msg: '发生错误：' + err.toString());
        });
      } else {
        this.widget.isSubmitting = false;
      }
    } else {
//      Fluttertoast.showToast(msg: '请等待保存结束');
    }
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String initialValue;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => new _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      initialValue: widget.initialValue,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: new InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        icon: Icon(Icons.vpn_key),
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child:
              new Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
