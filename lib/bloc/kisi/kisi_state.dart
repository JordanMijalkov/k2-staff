part of 'kisi_cubit.dart';

enum KisiStatus { preInit, initialized, ranging, rangingDone, unlocking }
enum KisiLockStatus { locked, unlocking }

class KisiState extends Equatable {
  KisiState({
    this.status = KisiStatus.preInit,
    this.lockingStatus = KisiLockStatus.locked,
    List<Beacon>? beaconList,
    this.bluetoothState = BluetoothState.stateOff,
    this.authorizationStatus = AuthorizationStatus.notDetermined,
    this.locationServiceEnabled = false
    }) : beacons = beaconList ?? []; 

  final KisiStatus status;
  final KisiLockStatus lockingStatus;
  late final List<Beacon> beacons;
  final BluetoothState bluetoothState;
  final AuthorizationStatus authorizationStatus;
  final bool locationServiceEnabled;

  KisiState copyWith({
    KisiStatus? status,
    KisiLockStatus? lockingStatus,
    List<Beacon>? beacons,
    BluetoothState? bluetoothState,
    AuthorizationStatus? authorizationStatus,
    bool? locationServiceEnabled
  }) {
    return KisiState(
      status: status ?? this.status,
      lockingStatus: lockingStatus ?? this.lockingStatus,
      beaconList: beacons ?? this.beacons,
      bluetoothState: bluetoothState ?? this.bluetoothState,
      authorizationStatus: authorizationStatus ?? this.authorizationStatus,
      locationServiceEnabled: locationServiceEnabled ?? this.locationServiceEnabled
    );
  }

  bool get bluetoothEnabled => bluetoothState == BluetoothState.stateOn;
  bool get authorizationStatusOk =>
      authorizationStatus == AuthorizationStatus.allowed ||
      authorizationStatus == AuthorizationStatus.always;

  @override
  List<Object?> get props => [status, lockingStatus, beacons];
}


