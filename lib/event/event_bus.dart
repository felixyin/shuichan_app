import 'package:event_bus/event_bus.dart';

class AppEventBus {
//  factory EventBus() => _getInstance();
  static EventBus _instance;

  static EventBus get singleton => _getInstance();

  AppEventBus._internal();

  static EventBus _getInstance() {
    if (null == _instance) {
      _instance = new EventBus();
    }
    return _instance;
  }
}
