import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:geolocator/geolocator.dart';
import './sim_info.dart';

import './device_info.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDeviceInfoLoaded = false;

  Permission permission;

  DeviceInfo deviceInfo;
  SimDataInfo simInfo;

  String longitude = '';
  String latitude = '';

  String _signalStrength = ' ';

  bool isClicked = false;
  bool isSignalClicked = false;

  static const signalStrengthChannel = const MethodChannel('signalStrength');

  @override
  void initState() {
    super.initState();
    requestPermission();
    deviceInfo = DeviceInfo();
    simInfo = SimDataInfo();
    setState(() {
      deviceInfo.getInfo();
      simInfo.getSimInfo();
    });
  }

  requestPermission() async {
    final ress =
        await SimplePermissions.requestPermission(Permission.ReadPhoneState);
    final res = await SimplePermissions.requestPermission(
        Permission.AccessFineLocation);
    print(ress);
    print(res);
  }

  _getLocation() async {
    final coords = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = coords.latitude.toString();
      longitude = coords.longitude.toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signal Detector'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              getRow('Brand', deviceInfo.brand),
              getRow('Model', deviceInfo.model),
              getRow('Device', deviceInfo.device),
              getRow('Version', deviceInfo.version),
              getRow('Android ID', deviceInfo.androidId),
              getRow('Processor', deviceInfo.processor),
              getRow('Manufacturer', deviceInfo.manufacturer),
              getRow('Allows VOIP', simInfo.allowsVOIP),
              getRow('Carrier Name', simInfo.carrierName),
              getRow('ISO Country Code', simInfo.isoCountryCode),
              getRow('Mobile Country Code', simInfo.mobileCountryCode),
              getRow('Mobile Network Code', simInfo.mobileNetworkCode),
              RaisedButton(
                onPressed: () {
                  _getLocation();
                  setState(() {
                    isClicked = true;
                  });
                },
                child: Text('Location'),
              ),
              isClicked ? getRow('Latitude', longitude) : SizedBox(),
              isClicked ? getRow('Longitude', latitude) : SizedBox(),
              RaisedButton(
                onPressed: () {
                  // _getSignalStrength();
                  setState(() {
                    isSignalClicked = true;
                  });
                },
                child: Text('Signal Strength'),
              ),
              isSignalClicked
                  ? getRow('Signal Strength', _signalStrength)
                  : SizedBox(),
            ]),
      ),
    );
  }

  Future<void> _getSignalStrength() async {
    String signalStrength;
    try {
      var result =
          await signalStrengthChannel.invokeMethod('getSignalStrength');
      signalStrength = result.toString();
    } on PlatformException catch (e) {
      signalStrength = 'Failed to get signal strength: ${e.message}';
    }
    setState(() {
      _signalStrength = signalStrength;
    });
  }

  Widget getRow(String heading, String answer) {
    return Row(
      children: <Widget>[
        Text(heading + ": "),
        Text(answer),
      ],
    );
  }

  Future _refresh() {
    deviceInfo.getInfo();
  }
}
