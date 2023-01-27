import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:k2_flutter_api/models/k2_kisi_lock.dart';
import 'package:k2_flutter_api/services/honeycomb_service.dart';
import 'package:k2_flutter_core/components/kt_scroll_behavior.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_flutter_core/services/get_locale.dart';
import 'package:k2_flutter_core/theme/bloc/theme_cubit.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/bloc/kisi/kisi_cubit.dart';
import 'package:k2_staff/core/services/app_routes.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/generated/l10n.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:permission_handler/permission_handler.dart';
class KTApp extends StatefulWidget {
  @override
  State<KTApp> createState() => _KTAppState();
}

class _KTAppState extends State<KTApp> with WidgetsBindingObserver {
  final routes = AppRoutes();
  final String defaultLocale = getLocale();
  final HoneycombService honeycombService = app<HoneycombService>();
  static const MethodChannel _kisiChannel = MethodChannel('com.kangarootime.k2.workforce/kisi_secure_unlock');
//static const MethodChannel _channel = MethodChannel('kisi_unlocker');
  static const MethodChannel _channel = MethodChannel('com.kangarootime.k2.workforce/suppressApplePay');

  final int lockTimer = Platform.isIOS ? 10 : 5;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isIOS) {
      setHandler();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onStart();
      });
    } else if (Platform.isAndroid) {
      initAndroidKisi();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print('disposing');
    _streamRanging?.cancel();
    super.dispose();
  }  

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('app resumed');
        break;
      case AppLifecycleState.paused:
        print('app paused');
        break;
      case AppLifecycleState.inactive:
        print('app inactive');
        break;
      case AppLifecycleState.detached:
        _onStop();
        break;
      default:
        print('app detached');
        break;
    }
  }

  initAndroidKisi() async {
    _rangeLocks();
  }

  setHandler() {
    _kisiChannel.setMethodCallHandler(methodCallHandler);
    _onSuppressApplePay();
  }

  _rangeLocks() async {
    var status = await Permission.bluetoothScan.request();
    var stat2 = await Permission.bluetoothConnect.request();
    await context.read<KisiCubit>().initLocks();
    await ranging();
  }

  static Future _onSuppressApplePay() async {
    await _channel.invokeMethod('DisableApplyPay');
  }

  String _prox(Proximity prox) {
    switch (prox) {
      case Proximity.far:
        return 'Far';
      case Proximity.near:
        return 'Near';
      case Proximity.immediate:
        return 'Immediate';
      default:
        return '';
    }
  }

  static Future _onStart() async {
    print('Starting Beacon Manager');
    await _kisiChannel.invokeMethod('BeaconManagerStart');
  }

  static Future _onStop() async {
    await _kisiChannel.invokeMethod('BeaconManagerStop');
  }

  Future<dynamic> methodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'secureUnlockSuccess':
        print(methodCall.arguments);
        return null;
      case 'secureUnlockFailure':
        print(methodCall.arguments);
        return null;
      case 'secureUnlockFetchCertificate':
        print(methodCall.arguments);
        return null;
      case 'secureUnlockLoginIDForOrganization':
        print(methodCall.arguments);
        return null;
      case 'secureUnlockPhoneKeyForLogin':
        print(methodCall.arguments);
        return null;
      case 'enterNotification':
        print("-----ENTER NOTIFICATION");
        print(methodCall.arguments); // entering the nearby reader
        return null;
      case 'exitNotification':
        print("-----EXIT NOTIFICATION");
        print(methodCall.arguments); // leaving the nearby reader
        return null;
      case 'BeaconRegionKey':
        print(methodCall.arguments); // beaconRegionKey
        return null;
      case 'BeaconLockIdPass':
        processUnlock(methodCall.arguments);
        print(methodCall.arguments); // array of BeaconLock(ID and Password)
        return null;
      default:
        throw PlatformException(code: 'notimpl', message: 'not implemented');
    }
  }

  StreamSubscription<RangingResult>? _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  List<int> lookUpBlock = [];

  void processUnlock(int lockId) async {
    K2KisiLock? lock;
    if (!lookUpBlock.contains(lockId)) {
      lock = (await context.read<KisiCubit>().getLockFromId(lockId)).lock;
      lookUpBlock.add(lockId);
      lockLookUp.putIfAbsent(lockId, () => lock!);
    } else
      lock = lockLookUp[lockId];

    if (null != lock) {
      if (lock.hasPermissionToUnlock!) {
        context.read<KisiCubit>().unlockKisiDoor(lock.lockId!, 0);
      }
    }
  }

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

  Future<void> ranging() async {
    bool fired = false;
    bool isLooking = false;
    K2KisiLock? lock;

    await flutterBeacon.initializeScanning;
    Proximity proximity = Proximity.unknown;

    _streamRanging = flutterBeacon.ranging(regions).listen((RangingResult result) {
      _regionBeacons[result.region] = result.beacons;

      if (context.read<AuthenticationCubit>().state.status == AuthenticationStatus.authenticated) {
        _regionBeacons.values.forEach((list) async {
          if (list.isNotEmpty) {
            Beacon b = list.first;
            proximity = b.proximity;
            // honeycombService.logWarning('ranging', [
            //   {'proximity', _prox(b.proximity)}
            // ]);
//            print('${DateTime.now()}  ${_prox(proximity)}');

            int lockId = context.read<KisiCubit>().getLockIdFromPair(b.major, b.minor);

            if (!lookUpBlock.contains(lockId) && !isLooking) {
              isLooking = true;
              // honeycombService.logWarning('lock-lookup', [
              //   {'lockid', lockId.toString()}
              // ]);
              lock = (await context.read<KisiCubit>().getLockFromId(lockId)).lock;

              if (null != lock) {
                // honeycombService.logWarning('lock-lookup-found', [
                //   {'id', lock!.id},
                //   {'centerid', lock!.centerId},
                //   {'lockid', lock!.lockId.toString()},
                //   {
                //     'hasPermissionToUnlock',
                //     lock!.hasPermissionToUnlock.toString()
                //   },
                // ]);
                //         print('lookup3: ${DateTime.now()}');
                lookUpBlock.add(lockId);
                lockLookUp.putIfAbsent(lockId, () => lock!);
                Timer(
                  const Duration(seconds: 8),
                  () {
                    isLooking = false;
                  },
                );
              }
            } else {
              if (!isLooking) {
                lock = lockLookUp[lockId]!;
              }
            }

            if (null != lock) {
              if (lock!.hasPermissionToUnlock! && fired == false && (proximity == Proximity.near || proximity == Proximity.immediate)) {
                fired = true;
                // honeycombService.logWarning('lock-unlock-try', [
                //   {'lockid', lockId.toString()}
                // ]);
                context.read<KisiCubit>().unlockKisiDoor(lock!.lockId!, 0);
                //     print('unlock2: ${DateTime.now()}');
                Timer(
                  
                  Duration(seconds: lockTimer),
                  () {
                    //              print('............reset lock.........');
                    fired = false;
                  },
                );
              }
            } else {
              print('lock is null');
            }

            _beacons.addAll(list);
          }
        });
      }
    }, onDone: () => print("ON DONE!!!"), onError: (err) => print("ON ERROR! - ${err.toString()}"));
  }

  List<K2KisiLock> availableLocks = []; // currently available locks
  Map<int, K2KisiLock> lockLookUp = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (BuildContext context, ThemeState state) => DismissKeyboard(
        child: MaterialApp.router(
          title: 'Kangarootime For Staff',
          //    locale: Locale(const String.fromEnvironment('LOCALE')),
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode,
          theme: state.lightTheme(),
//          darkTheme: state.darkTheme(),
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          localeListResolutionCallback: (locale, supportedLocales) => Locale(defaultLocale.substring(0, 2), defaultLocale.substring(3, 5)),
          routeInformationParser: QRouteInformationParser(),
          routerDelegate: QRouterDelegate(routes.routes()),
          builder: (BuildContext widget, Widget? child) => kIsWeb
              ? KTMessage(
                  child: child!,
                )
              : ScrollConfiguration(
                  behavior: const KTScrollBehavior(),
                  child: KTMessage(
                    child: child!,
                  ),
                ),
        ),
      ),
    );
  }
}

// The DismissKeybaord widget (it's reusable)
class DismissKeyboard extends StatelessWidget {
  final Widget child;
  DismissKeyboard({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: child,
    );
  }
}
