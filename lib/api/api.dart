class Api {
//  static const String BASE_URL = 'http://192.168.3.4:8080';

  static const String BASE_URL = 'http://gongchang.qdbak.com';

  /// 用于登录接口
  static const String ADMIN_URL = BASE_URL + '/bak/a';

  /// 用于数据查询
  static const String APP_URL = ADMIN_URL + '/app';

  /// 登陆
  static const String DO_LOGIN = ADMIN_URL + '/login';

  /// 退出登陆
  static const String LOGOUT = ADMIN_URL + '/logout';

  /// 检查版本
  static const String VERSION = APP_URL + '/getAppVersion';

  /// 验证登陆
  static const String CHECK_LOGIN = APP_URL + '/checkLogin';

  /// 获取用户信息
  static const String GET_USER_INFO = APP_URL + '/getUserInfo';

  /// 修改用户信息
  static const String SAVE_USER_INFO = APP_URL + '/saveUserInfo';

  /// 包装人员扫码
  static const String SCAN_QR_CODE = ADMIN_URL + '/order/scOrder/scanBoxOrder';

  /// 包转人员上传照片
  static const String UPLOAD_PHOTO = APP_URL + '/uploadPhoto';

  /// 包装人员代办任务列表
  static const String FIND_PACKAGER_TODO_LIST =
      APP_URL + '/findTodoListForPackager';

  /// 包装人员历史任务列表
  static const String FIND_PACKAGER_HISTORY_LIST =
      APP_URL + '/findHistoryListForPackager';

  /// 快递人员代办任务列表
  static const String FIND_COURIER_TODO_LIST =
      APP_URL + '/findTodoListForCourier';

  /// 快递人员历史任务列表
  static const String FIND_COURIER_HISTORY_LIST =
      APP_URL + '/findHistoryListForCourier';

  /// 获取所有工厂
  static const String FIND_ALL_OFFICE = APP_URL + '/findAllOffice';

  /// 获取用户设置
  static const String GET_USER_SETTING = APP_URL + '/loadSetting';

  /// 保存用户设置
  static const String SAVE_USER_SETTING = APP_URL + '/saveSetting';
}
