import 'package:flutter/material.dart';
import 'package:shuichan_app/model/user_bean.dart' as User;
import 'package:shuichan_app/view/my/my_info_edit_page.dart';
import 'package:shuichan_app/view/my/user_info_widget.dart';

class MyInfoPage extends StatefulWidget {
  final User.DataBean userBean;

  MyInfoPage(this.userBean);

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  @override
  Widget build(BuildContext context) {
    Widget buildRow(child, title, isEnd, onTap) {
      final Row row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: !isEnd
                  ? BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0xffd9d9d9), width: .3)))
                  : null,
              padding: EdgeInsets.only(top: 16.0),
              margin: EdgeInsets.only(left: 15.0),
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
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 15.0, right: 5.0),
                          child: child,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 15.0, right: 10.0),
                          child: onTap != null
                              ? Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                  size: 22,
                                )
                              : Container(),
                        )
                      ],
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

    // 头像组件
    Widget userImage = new UserIconWidget(
        padding: const EdgeInsets.only(right: 0.0),
        width: 55.0,
        height: 55.0,
        image: this.widget.userBean.photo,
        isNetwork: true,
        onPressed: () {
          // NavigatorUtils.goPerson(context, eventViewModel.actionUser);
        });

    return new Scaffold(
      appBar: AppBar(
        title: Text('个人信息'),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.mode_edit),
              tooltip: '修改',
              onPressed: () {
                // do nothing
//                Application.router.navigateTo(context, Routes.my);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (c) {
                      return MyInfoEditPage(this.widget.userBean);
                    },
                  ),
                );
              }),
        ],
      ),
      body: new SingleChildScrollView(
        child: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildRow(userImage, '头像', false, null),
              buildRow(
                  Text(
                    this.widget.userBean.name,
                    style: TextStyle(color: Colors.grey, fontSize: 18.0),
                  ),
                  '姓名',
                  false,
                  null),
              buildRow(
                  Text(
                    this.widget.userBean.mobile,
                    style: TextStyle(color: Colors.grey, fontSize: 18.0),
                  ),
                  '电话',
                  false,
                  null),
              buildRow(
                  Text(
                    this.widget.userBean.loginName,
                    style: TextStyle(color: Colors.grey, fontSize: 18.0),
                  ),
                  '登录账号',
                  false,
                  null),
              buildRow(
                  Text(
                    this.widget.userBean.roleNames,
                    style: TextStyle(color: Colors.grey, fontSize: 18.0),
                  ),
                  '登录角色',
                  false,
                  null),
              buildRow(
                  Text(
                    this.widget.userBean.company.name,
                    style: TextStyle(color: Colors.grey, fontSize: 18.0),
                  ),
                  '所属公司',
                  true,
                  null),

//              buildRow(Text(''), '更多', true),
            ],
          ),
        ),
      ),
    );
  }
}
