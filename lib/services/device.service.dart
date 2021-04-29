import 'package:wakelock/wakelock.dart';

class DeviceService {
  // ignore: avoid_positional_boolean_parameters
  Future<void> setKeepScreenAwake(bool keepAwake) {
    return keepAwake ? Wakelock.enable() : Wakelock.disable();
  }
}
