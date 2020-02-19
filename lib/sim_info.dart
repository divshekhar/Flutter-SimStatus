import 'package:sim_info/sim_info.dart';

class SimDataInfo {
  String _allowsVOIP = 'Unknown';
  String _carrierName = 'Unknown';
  String _isoCountryCode = 'Unknown';
  String _mobileCountryCode = 'Unknown';
  String _mobileNetworkCode = 'Unknown';

  SimDataInfo() {
    getSimInfo();
  }

  void getSimInfo() async {
    _allowsVOIP = await SimInfo.getAllowsVOIP;
    _carrierName = await SimInfo.getCarrierName;
    _isoCountryCode = await SimInfo.getIsoCountryCode;
    _mobileCountryCode = await SimInfo.getMobileCountryCode;
    _mobileNetworkCode = await SimInfo.getMobileNetworkCode;
  }

  get allowsVOIP => _allowsVOIP;
  get carrierName => _carrierName;
  get isoCountryCode => _isoCountryCode;
  get mobileNetworkCode => _mobileNetworkCode;
  get mobileCountryCode => _mobileCountryCode;
}
