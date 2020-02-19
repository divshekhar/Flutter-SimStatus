import 'package:device_info/device_info.dart';

class DeviceInfo {
  String _model = 'Unknown';
  String _androidId = 'Unknown';
  String _device = 'Unknown';
  String _version = 'Unknown';
  String _brand = 'Unknown';
  String _processor = 'Unknown';
  String _manufacturer = 'Unknown';

  DeviceInfo() {
    getInfo();
  }

  Future getInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    AndroidBuildVersion androidBuildVersion = androidInfo.version;
    _model = androidInfo.model;
    _androidId = androidInfo.androidId;
    _device = androidInfo.device;
    _version = androidBuildVersion.release;
    _brand = androidInfo.brand;
    _processor = androidInfo.hardware;
    _manufacturer = androidInfo.manufacturer;
  }

  get model {
    return _model;
  }

  get androidId {
    return _androidId;
  }

  get version {
    return _version;
  }

  get brand {
    return _brand;
  }

  get device {
    return _device;
  }

  get processor {
    return _processor;
  }

  get manufacturer {
    return _manufacturer;
  }
}
