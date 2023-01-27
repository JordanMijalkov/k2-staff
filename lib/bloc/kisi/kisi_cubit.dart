import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:k2_flutter_api/api/responses/GetTimeEntriesForPersonAtCenterResponse.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'dart:async';

import 'package:k2_staff/core/services/service_locator.dart';

part 'kisi_state.dart';

class KisiCubit extends Cubit<KisiState> {
  KisiCubit() : super(KisiState());

  final CoreApiService coreApiService = app<K2CoreApiClient>();
  final HoneycombService honeycombService = app<HoneycombService>();

  final regions = <Region>[
    Region(
      identifier: 'beacon1',
      proximityUUID: '6dfe2064-5186-11ea-8dfe-4b73218bf946'.toUpperCase(),
    ),
    Region(
      identifier: 'beacon2',
      proximityUUID: '6f9e62a8-5186-11ea-8ed0-4314341d01dd'.toUpperCase(),
    ),
    Region(
      identifier: 'beacon3',
      proximityUUID: '71fb9eb2-5186-11ea-b1f4-bb928fefb7fd'.toUpperCase(),
    ),
    Region(
      identifier: 'beacon4',
      proximityUUID: '73f789ec-5186-11ea-9973-87896ce82dd8'.toUpperCase(),
    ),
    Region(
      identifier: 'beacon5',
      proximityUUID: '74689eac-5186-11ea-be2d-27ec120c3b0f'.toUpperCase(),
    ),
  ];

  StreamSubscription<RangingResult>? _streamRanging;
  StreamSubscription<MonitoringResult>? _streamMonitoring;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];

  Future<void> initLocks() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
//    updateBluetoothState(bluetoothState);
    print('BLUETOOTH $bluetoothState');

    final authorizationStatus = await flutterBeacon.authorizationStatus;
    //updateAuthorizationStatus(authorizationStatus);
    print('AUTHORIZATION $authorizationStatus');

    final locationServiceEnabled =
        await flutterBeacon.checkLocationServicesIfEnabled;
    // updateLocationService(locationServiceEnabled);
    print('LOCATION SERVICE $locationServiceEnabled');

    if (authorizationStatus != AuthorizationStatus.allowed &&
        authorizationStatus != AuthorizationStatus.always)
      await flutterBeacon.requestAuthorization;

    honeycombService.logWarning('init', [
      {'bluetooth', bluetoothState.value},
      {'authorizationStatus', authorizationStatus.value},
      {'locationServiceEnabled', locationServiceEnabled}
    ]);

    emit(state.copyWith(
        status: KisiStatus.initialized,
        bluetoothState: bluetoothState,
        authorizationStatus: authorizationStatus,
        locationServiceEnabled: locationServiceEnabled));
  }

  Future<void> ranging() async {
    honeycombService.logWarning('ranging-started', []);
    //regions.add(Region(identifier: 'com.beacon'));
    // List pairs = [];
    // to start monitoring beacons
    // _streamMonitoring = flutterBeacon.monitoring(regions).listen((MonitoringResult result) {
    //   print (result.toString());
    //_regionBeacons[result.region] = result.;
    // result contains a region, event type and event state
    // });
    await flutterBeacon.initializeScanning;
    _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
      _regionBeacons[result.region] = result.beacons;
      _beacons.clear();
      _regionBeacons.values.forEach((list) {
        _beacons.addAll(list);
      });
      emit(state.copyWith(status: KisiStatus.ranging, beacons: _beacons));
      emit(state.copyWith(status: KisiStatus.rangingDone));
    });
  }

  convertTo16bitsBinary(num) {
    var n = num.toRadixString(2);
    n = "0000000000000000".substring(n.length) + n;
    return n;
  }

  int getLockIdFromPair(int major, int minor) {
    return int.parse(
        (convertTo16bitsBinary(major) + convertTo16bitsBinary(minor))
            .substring(0, 22),
        radix: 2);
  }

  Future<GetLockByIdResponse> getLockFromId(int lockId) async {
    return await coreApiService.getLockByLockId(lockId);
  }

  Future<void> unlockKisiDoor(int lockId, double distance) async {
    List pairs = [];
    pairs.add({'lock ID', lockId});
    pairs.add({'distance', distance});
    HoneycombEvent rootEvent =
        honeycombService.createEvent('kisi_unlock', 'root', pairs, null);
    var qr = await coreApiService.unlockLock(lockId, null);
    pairs.add({'qr_exception', qr?.exception?.toString() ?? ''});
    pairs.add({'qr_data', qr?.data?.toString() ?? ''});
    rootEvent.closeHoneyCombEvent();
    print("Unlocked....");
    //print(qr.toString());
  }

  double _distance(rssiVal) {
    //MeasuredPower is a constant defined by the manufacturing of the device
    //also known as the 1 Meter RSSI
    //-69 (for kontakt BLE beacons)
    double measuredPowerConstantDeviceManufacturer = -69;

    //N constant depends on the Environmental factor. Range 2-4
    double nConstantEnvironmental = 2;

    double baseConstant = 10;

    //calculation to convert rssi value to a distance in meters
    //source: estimo - https://iotandelectronics.wordpress.com/2016/10/07/how-to-calculate-distance-from-the-rssi-value-of-the-ble-beacon/
    //calc double distance = 10 ^ ((Measured Power - RSSI)/(10 * N))

    double partA = measuredPowerConstantDeviceManufacturer - rssiVal;
    double partB = baseConstant * nConstantEnvironmental;
    double exponent = (partA / partB);
    num distance = pow(baseConstant, exponent);

    return double.parse(distance.toStringAsFixed(2));
  }

  void newLockRanged() {}

  void lockOutofRange() {}
}
