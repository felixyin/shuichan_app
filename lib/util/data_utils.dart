import 'dart:async' show Future;
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shuichan_app/api/api.dart';
import 'package:shuichan_app/model/courier_todo_bean.dart' as ct;
import 'package:shuichan_app/model/factory_bean.dart' as f;
import 'package:shuichan_app/model/login_bean.dart';
import 'package:shuichan_app/model/packager_scan_bean.dart' as PackagerScan;
import 'package:shuichan_app/model/packager_todo_bean.dart' as PackagerTodo;
import 'package:shuichan_app/model/upload_photo_bean.dart';
import 'package:shuichan_app/model/user_bean.dart' as User;
import 'package:shuichan_app/model/user_info_cache.dart';
import 'package:shuichan_app/model/user_setting_bean.dart' as us;
import 'package:shuichan_app/model/version.dart';
import 'package:shuichan_app/util/http/net_utils.dart';

class DataUtils {
  /// 登录
  /// {success: true, errorCode: -1, msg: 登录成功!, body: {username: admin,
  /// name: 尹彬, mobileLogin: true, JSESSIONID: cd07d207a770461099dea7dced74326e}}
  static Future<LoginBean> doLogin(Map<String, String> params) async {
    var response;
    try {
//      response = await NetUtils.post(Api.DO_LOGIN, data: params);

      params.addAll({"mobileLogin": "true"});
      response =
          await NetUtils.getDio().post(Api.DO_LOGIN, queryParameters: params);
      log(response);
    } catch (e) {
      log("-------------------===================>");
      log(e.toString());
    }

    log(response.data.toString());
//    UserInfo userInfo = UserInfo.fromJson(response.data);
//    return userInfo;
    LoginBean loginBean = LoginBean.fromJson(response.data);

    return loginBean;
  }

  /// 验证登陆
  static Future<bool> checkLogin() async {
    var response = await NetUtils.get(Api.CHECK_LOGIN);
    log('验证登陆：$response');
    return response.data;
  }

  /// 退出登陆
  static Future<bool> logout() async {
    var response = await NetUtils.get(Api.LOGOUT);
    log('退出登陆 $response');
    return Future.value(true);
  }

  /// 检查是否有新版本
  /// {"status":200,"data":{"version":"0.0.2","name":"FlutterGo"},"success":true}
  static Future<Version> checkVersion(Map<String, dynamic> params) async {
    var response = await NetUtils.get(Api.VERSION, queryParameters: params);

    Version version = Version.formJson(response.data);

    return version; // 1表示服务器有新的版本
  }

  /// 获取用户信息
  /// {"data":{"id":"1","company":{"id":"bebcff27abc246beac0883a08251de78",
  /// "name":"前途软件测试加工厂","sort":30,"hasChildren":false,"type":"2",
  /// "parentId":"0"},"office":{"id":"3783744abd8e4721bf8f6e200622e288",
  /// "sort":30,"hasChildren":false,"type":"2","parentId":"0"},
  /// "loginName":"admin","no":"000","name":"尹彬","email":"yinbin@qdqtrj.com",
  /// "phone":"17554153785","mobile":"17554153785","loginFlag":"1",
  /// "photo":"/bak/userfiles/1/程序附件/sys/user/images/icon.jpg",
  /// "roleNames":"佰安客系统管理员","admin":true},"success":true,"status":200}
  static Future<User.UserBean> getUserInfo() async {
    var response = await NetUtils.post(Api.GET_USER_INFO, data: null);
    log('userinfo:', error: response);
    return User.UserBean.fromJson(response.data);
  }

  /// 保存用户信息
  static Future<int> saveUserInfo(User.DataBean userBean) async {
    User.DataBean dataBean = User.DataBean.fromJson(userBean.toJson()); // 深度复制
    dataBean.company = null;
    dataBean.office = null;
    if (null != dataBean.password && dataBean.password.isNotEmpty) {
      UserInfoControlModel _userInfoControlModel = new UserInfoControlModel();
      _userInfoControlModel.getAllInfo().then((list) {
        if (list.length > 0) {
          UserInfo _userInfo = list[0];
          log('获取的数据：${_userInfo.username} ${_userInfo.password}');
          _userInfoControlModel.deleteAll().then((result) {
            // log('删除结果：$result');
            _userInfoControlModel
                .insert(UserInfo(password: '', username: _userInfo.username))
                .then((value) {
              log('存储成功:$value');
            });
          });
        }
      });
      var response =
          await NetUtils.post(Api.SAVE_USER_INFO, data: dataBean.toJson());
      var success = response.data['success'];
      return success == true ? 2 : 0;
    } else {
      var response =
          await NetUtils.post(Api.SAVE_USER_INFO, data: dataBean.toJson());
      var success = response.data['success'];
      return success ? 1 : 0;
    }
  }

  /// 包装人员扫码
  static Future<PackagerScan.BodyBean> scanQrCode(String barcodeUrl) async {
    Map<String, dynamic> data = Map.identity();
    data.putIfAbsent("device", () => "app");
    var response = await NetUtils.post(barcodeUrl, data: data);
    return PackagerScan.PackagerScanBean.fromJson(response.data).body;
  }

  /// 包装人员拍照上传
  static Future<UploadPhotoBean> uploadPhoto(
      String boxItemId, File image) async {
    String imgName = image.path.substring(image.path.lastIndexOf("/") + 1);
    FormData formData = FormData.fromMap({
      "upload": await MultipartFile.fromFile(image.path, filename: imgName),
      "boxItemId": boxItemId,
    });
    BaseOptions _baseOptions = BaseOptions(
      connectTimeout: 30000,
      receiveTimeout: 20000,
      contentType: "multipart/form-data",
    );
    Dio _dio = Dio(_baseOptions);
    var response = await _dio.post(NetUtils.authUrl(Api.UPLOAD_PHOTO),
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
        ));
    log("", error: response);
    return UploadPhotoBean.fromJson(response.data);
  }

  /// 包装人员今天代办任务列表
  static Future<List<PackagerTodo.DataBean>> findPackagerTodoList() async {
    var response = await NetUtils.post(Api.FIND_PACKAGER_TODO_LIST, data: null);
    return PackagerTodo.PackagerTodoBean.fromJson(response.data).data;
  }

  /// 包装人员已完成的任务列表
  static Future<List<PackagerTodo.DataBean>> findPackagerHistoryList(
      String dateStr) async {
    Map<String, dynamic> data = Map.identity();
    data.putIfAbsent("historyDateStr", () => dateStr);
    var response =
        await NetUtils.post(Api.FIND_PACKAGER_HISTORY_LIST, data: data);
    return PackagerTodo.PackagerTodoBean.fromJson(response.data).data;
  }

  /// 快递人员今天代办任务列表
  static Future<List<ct.Data>> findCourierTodoList(String factoryId) async {
    Map<String, dynamic> data = Map.identity();
    data.putIfAbsent("factoryId", () => factoryId);
    var response = await NetUtils.post(Api.FIND_COURIER_TODO_LIST, data: data);
    return ct.CourierTodo.fromJson(response.data).data;
  }

  /// 快递人员已完成的任务列表
  static Future<List<ct.Data>> findCourierHistoryList(
      String dateStr, String factoryId) async {
    Map<String, dynamic> data = Map.identity();
    data.putIfAbsent("historyDateStr", () => dateStr);
    data.putIfAbsent("factoryId", () => factoryId);
    var response =
        await NetUtils.post(Api.FIND_COURIER_HISTORY_LIST, data: data);
    return ct.CourierTodo.fromJson(response.data).data;
  }

  /// 获取所有工厂
  static Future<List<f.Data>> findAllOffice() async {
    var response = await NetUtils.post(Api.FIND_ALL_OFFICE, data: null);
    return f.Factory.fromJson(response.data).data;
  }

  /// 获取用户设置信息
  static Future<us.Body> getUserSetting() async {
    var response = await NetUtils.post(Api.GET_USER_SETTING, data: null);
//    log('', error: response);
    return us.UserSetting.fromJson(response.data).body;
  }

  /// 保存用户设置信息
  static Future<bool> saveUserSetting(us.Body setting) async {
//    Map<String, dynamic> data = Map.identity();
//    data.putIfAbsent("setting", () => setting);
    await NetUtils.post(Api.SAVE_USER_SETTING, data: setting.toJson());
    return true;
  }
}
