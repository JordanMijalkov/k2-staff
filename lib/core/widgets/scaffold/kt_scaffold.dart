import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'package:k2_flutter_api/models/k2_kisi_lock.dart';
import 'package:k2_flutter_api/models/k2_staff_profile.dart';
import 'package:k2_flutter_core/components/kt_background.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/bloc/kisi/kisi_cubit.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/core/widgets/k2_staff_profile_widget.dart';
import 'dart:async';

import 'package:k2_staff/core/widgets/scaffold/app_bar_phone.dart';

/// A convenience Widget that wraps a [Scaffold] to build a transparent [AppBar]
/// on top of a [KTBackground].
///
/// If [showIcon] is `true`, the [FlareIcon.harpyLogo] is built next to the
/// [title] in the [AppBar].
class KTScaffold extends StatefulWidget {
  const KTScaffold({
    required this.body,
    this.title,
    this.showIcon = false,
    this.actions,
    this.drawer,
    this.endDrawer,
    this.endDrawerEnableOpenDragGesture = true,
    this.backgroundColor,
    this.appBarBottom,
    this.floatingActionButton,
    this.buildSafeArea = false,
    this.showLeading = true
  });

  final String? title;
  final Widget body;
  final bool showIcon;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool endDrawerEnableOpenDragGesture;
  final PreferredSizeWidget? appBarBottom;
  final Widget? floatingActionButton;
  final bool buildSafeArea;
  final bool showLeading;
  final Color? backgroundColor;

  @override
  State<KTScaffold> createState() => _KTScaffoldState();
}

class _KTScaffoldState extends State<KTScaffold> {
  final GlobalKey _heightKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // context.read<KisiCubit>().initLocks();
    // context.read<KisiCubit>().ranging();
  }

  @override
  void dispose() {
   //  context.read<KisiCubit>().close();
    super.dispose();
  }


  Map<int, K2KisiLock> lockLookUp = {};
  List<int> lookUpBlock = []; // r
  bool fired = false;

  Future<LockDetails?> _parseBeacons(List<Beacon> beacons) async {
    var iosDistance = -1.0;

    for (var beacon in beacons) {
//    beacons.forEach((beacon) async {
  print ('Rssi: ${beacon.rssi}');
      int lockId = context
          .read<KisiCubit>()
          .getLockIdFromPair(beacon.major, beacon.minor);

      if (!lookUpBlock.contains(lockId)) {
        lookUpBlock.add(lockId);

        var lock = (await context.read<KisiCubit>().getLockFromId(lockId)).lock;
        lockLookUp.putIfAbsent(lockId, () => lock);

        // if (Platform.isIOS) {
        //   iosDistance = _distance(beacon.txPower, beacon.rssi);
        // }

        if (lock.hasPermissionToUnlock ?? false) {
          return (LockDetails(
              lockId: lock.lockId!,
              accuracy: beacon.accuracy,
              proximity: beacon.proximity,
              iosDistance: iosDistance));
        }
      } else {
        if (lockLookUp.containsKey(lockId)) if (lockLookUp[lockId]!
            .hasPermissionToUnlock ?? false) {
        // if (Platform.isIOS) {
        //   iosDistance = _distance(beacon.txPower, beacon.rssi);
        // }              
          return (LockDetails(
              lockId: lockLookUp[lockId]!.lockId!,
              accuracy: beacon.accuracy,
              proximity: beacon.proximity,
              iosDistance: iosDistance));
        }
      }
    }

    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KisiCubit, KisiState>(builder: (context, state) {
      if (state.beacons.isEmpty)
        return _scaffold(Proximity.unknown, -1);
      else
        return 
        _scaffold(Proximity.unknown, -1);
        FutureBuilder(
            future: _parseBeacons(state.beacons),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                LockDetails l = snapshot.data as LockDetails;
                if (l.proximity == Proximity.immediate && fired == false) {
                  fired = true;
                  context.read<KisiCubit>().unlockKisiDoor(l.lockId, 0);

                  Timer(
                    const Duration(seconds: 5),
                    () {
                      print('............reset.........');
                      fired = false;
                    },
                  );
                }
                // if (l.accuracy < 1.0)
                //   EasyDebounce.debounce(
                //       'lock-debouncer', // <-- An ID for this particular debouncer
                //       Duration(seconds: 8), // <-- The debounce duration
                //       () => context
                //           .read<KisiCubit>()
                //           .unlockKisiDoor(l.lockId, 0) // <-- The target method
                //       );
                return _scaffold(l.proximity, l.iosDistance);
              } else
                return _scaffold(Proximity.unknown, -1);
            });
    });
  }

  Widget _scaffold(proximity, iosDistance) {
    return 
    
    
            
     Scaffold(
        drawer: widget.drawer,
     appBar: widget.showLeading ? AppBar(
       toolbarHeight: 75,
       centerTitle: true,
       backgroundColor: Theme.of(context).colorScheme.secondary,
       elevation: 1.5,
       title: BlocBuilder<AuthenticationCubit, AuthenticationState>(
         builder: (context, state) {
           return Text(
               state.staffProfile?.fullName ?? 'No current staff member');
         },
       ),
       actions: <Widget>[
         BlocBuilder<AuthenticationCubit, AuthenticationState>(
           builder: (context, state) {
             return Center(
               child: Container(
                 child: Padding(
                   padding: const EdgeInsets.symmetric(vertical: 6.0),
                   child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         state.staffProfile?.avatarWidget() ??
                             Container()
                       ]),
                 ),
               ),
             );
           },
         ),
         SizedBox(
           width: 18.0,
         ),

       ],
     ) : null,        
        endDrawer: widget.endDrawer,
        endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
        body: Column(
     children: <Widget>[
        //    _buildAppBar(theme, mediaQuery, _k2staffProfile),
       Expanded(
         child: widget.buildSafeArea ? SafeArea(top: false, child: widget.body) : widget.body,
       ),
     ],
        ),
      );
    
    
    
  }

// final HoneycombService honeycombService = app<HoneycombService>();

//   StreamSubscription<RangingResult>? _streamRanging;
//   final _regionBeacons = <Region, List<Beacon>>{};
//   final _beacons = <Beacon>[];
//   //final controller = Get.find<RequirementStateController>();

//   @override
//   void initState() {
//     super.initState();
//  K2StaffProfile _k2staffProfile =
//         context.read<AuthenticationCubit>().state.staffProfile!;
//     // controller.startStream.listen((flag) {
//     //   if (flag == true) {

//       // context.read<KisiCubit>().initLocks();
//       // context.read<KisiCubit>().ranging();
      
//       //checkAllRequirements();
//        // scanForBeacons(_k2staffProfile.fullName);

//   }
// //  var bluetoothState = BluetoothState.stateOff;
// //    var authorizationStatus = AuthorizationStatus.notDetermined;
// //   var locationService = false;

// //   checkAllRequirements() async {
// //     final bluetoothState = await flutterBeacon.bluetoothState;
// //     updateBluetoothState(bluetoothState);
// //     print('BLUETOOTH $bluetoothState');

// //     final authorizationStatus = await flutterBeacon.authorizationStatus;
// //     updateAuthorizationStatus(authorizationStatus);
// //     print('AUTHORIZATION $authorizationStatus');

// //     final locationServiceEnabled =
// //         await flutterBeacon.checkLocationServicesIfEnabled;
// //     updateLocationService(locationServiceEnabled);
// //     print('LOCATION SERVICE $locationServiceEnabled');

// //     if (authorizationStatus != AuthorizationStatus.allowed)
// //       await flutterBeacon.requestAuthorization;

// //     if (bluetoothEnabled &&
// //         authorizationStatusOk &&
// //         locationServiceEnabled) {
// //       print('STATE READY');
// //     //   if (currentIndex == 0) {
// //     //     print('SCANNING');
// //     //     controller.startScanning();
// //     //   } else {
// //     //     print('BROADCASTING');
// //     //     controller.startBroadcasting();
// //     //   }
// //     // } else {
// //     //   print('STATE NOT READY');
// //     //   controller.pauseScanning();
// //      }
// //   }
 


// //     bool get bluetoothEnabled => bluetoothState == BluetoothState.stateOn;
// //   bool get authorizationStatusOk =>
// //       authorizationStatus == AuthorizationStatus.allowed ||
// //       authorizationStatus == AuthorizationStatus.always;
// //   bool get locationServiceEnabled => locationService;


// //   updateBluetoothState(BluetoothState state) {
// //     bluetoothState = state;
// //   }

// //   updateAuthorizationStatus(AuthorizationStatus status) {
// //     authorizationStatus = status;
// //   }

// //   updateLocationService(bool flag) {
// //     locationService = flag;
// //   }



//   scanForBeacons(String staffmember) async {
//   StreamSubscription<RangingResult>? _streamRanging;
//   final _beacons = <Beacon>[];
//   final _regionBeacons = <Region, List<Beacon>>{};
//     await flutterBeacon.initializeScanning;
//     // if (!controller.authorizationStatusOk ||
//     //     !controller.locationServiceEnabled ||
//     //     !controller.bluetoothEnabled) {
//     //   print(
//     //       'RETURNED, authorizationStatusOk=${controller.authorizationStatusOk}, '
//     //       'locationServiceEnabled=${controller.locationServiceEnabled}, '
//     //       'bluetoothEnabled=${controller.bluetoothEnabled}');
//     //   return;
//     // }

//     final regions = <Region>[
//       Region(
//         identifier: 'beacon1',
//         proximityUUID: '6dfe2064-5186-11ea-8dfe-4b73218bf946'.toUpperCase(),
//       ), 
//       Region(
//         identifier: 'beacon2',
//         proximityUUID: '6f9e62a8-5186-11ea-8ed0-4314341d01dd'.toUpperCase(),
//       ),    
//       Region(
//         identifier: 'beacon3',
//         proximityUUID: '71fb9eb2-5186-11ea-b1f4-bb928fefb7fd'.toUpperCase(),
//       ),                     
//       Region(
//         identifier: 'beacon4',
//         proximityUUID: '73f789ec-5186-11ea-9973-87896ce82dd8'.toUpperCase(),
//       ),
//       Region(
//         identifier: 'beacon5',
//         proximityUUID: '74689eac-5186-11ea-be2d-27ec120c3b0f'.toUpperCase(),
//       ),
//     ];

//     // if (_streamRanging != null) {
//     //   if (_streamRanging!.isPaused) {
//     //     _streamRanging?.resume();
//     //     return;
//     //   }
//     // }
// bool allowunlock = true;
// bool report = true;
//     List pairs = [];

// _streamRanging =
//         flutterBeacon.ranging(regions).listen((RangingResult result) {
//      // print(result);
//       _regionBeacons[result.region] = result.beacons;

//       _regionBeacons.values.forEach((list) {
//         list.forEach((beacon) async { 

//      //   if (beacon.proximity == Proximity.immediate || beacon.proximity == Proximity.near) {
//         if (beacon.rssi > -70 && beacon.rssi < 0) {
//           pairs = [];
//           int lockId = int.parse((convertTo16bitsBinary(beacon.major) + convertTo16bitsBinary(beacon.minor)).substring(0,22), radix: 2);

//          // await context.read<ApplicationCubit>().unlockKisiDoor(lockId);
//           //throttle(() {
//             if (allowunlock) {
//               pairs.add({'staff', staffmember});
//                         pairs.add({'rssi', beacon.rssi});
//                         pairs.add({'lock ID', lockId});

//               allowunlock = false;
//             print("UNLOCKING: Rssi ${beacon.rssi}");
//                 HoneycombEvent rootEvent =
//         honeycombService.createEvent('beacon', 'root', pairs, null);
//             //context.read<ApplicationCubit>().unlockKisiDoor(lockId);
//           rootEvent.closeHoneyCombEvent();
//             }

//             Future.delayed(const Duration(seconds: 5), () {
//               allowunlock = true;
//             });
//          // }, const Duration(seconds: 2));
          
//         }
// //         else if (beacon.rssi != 0 && report) {
// //           report = false;

// // pairs = [];
// // pairs.add({'staff', staffmember});
// //                        pairs.add({'rssi', beacon.rssi});
// //                        pairs.add({'major', beacon.major});
// //                        pairs.add({'minor', beacon.minor});
// //                        HoneycombEvent rootEvent =honeycombService.createEvent('beacon_out_of_range', 'root', pairs, null);
// //                        rootEvent.closeHoneyCombEvent();
// //         }
// //                     Future.delayed(const Duration(seconds: 10), () {
// //               report = true;
// //             });
//           });
//       });
//     //   if (beacon.proximity == Proximity.near)
//     //     QR.to('/clockInOut');      
//       // if (mounted) {
//       //   setState(() {
//       //     _regionBeacons[result.region] = result.beacons;
//       //     _beacons.clear();
//       //     _regionBeacons.values.forEach((list) {
//       //       _beacons.addAll(list);
//       //     });
//       //     _beacons.sort(_compareParameters);
//       //   });
//       // }
//     });

//     // _streamRanging =
        
//     //     flutterBeacon.ranging(regions).listen((RangingResult result) {
//     //           result.beacons.forEach((beacon) {
//     //   print("_doBLERangingForBeacons() found new beacon: " + beacon.toString());
//     //   if (beacon.proximity == Proximity.near)
//     //     QR.to('/clockInOut');
//     //  });
//        // print(result);
//        // if (result.)
//       // if (mounted) {
//       //   setState(() {
//       //     _regionBeacons[result.region] = result.beacons;
//       //     _beacons.clear();
//       //     _regionBeacons.values.forEach((list) {
//       //       _beacons.addAll(list);
//       //     });
//       //     _beacons.sort(_compareParameters);
//       //   });
//       // }
//    // });
//   }

//   convertTo16bitsBinary(num) {
//   var n = num.toRadixString(2);
//   n = "0000000000000000".substring(n.length) + n;
//   return n;
// }

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
// //    final MediaQueryData mediaQuery = MediaQuery.of(context);
//     // K2StaffProfile _k2staffProfile =
//     //     context.read<AuthenticationCubit>().state.staffProfile!;
        
//     return SafeArea(
//           child: Scaffold(
//         drawer: widget.drawer,
//           appBar: AppBar(
//             toolbarHeight: 75,
//             centerTitle: true,
//             backgroundColor: theme.colorScheme.secondary,
//             elevation: 1.5,
//             title: BlocBuilder<AuthenticationCubit, AuthenticationState>(
//               builder: (context, state) {
//                 return Text(
//                     state.staffProfile?.fullName ?? 'No current staff member');
//               },
//             ),
//             actions: <Widget>[
//               BlocBuilder<AuthenticationCubit, AuthenticationState>(
//                 builder: (context, state) {
//                   return GestureDetector(
//                     onDoubleTap: () {
//                       // SessionBloc b = BlocProvider.of<SessionBloc>(context);
//                       // showDialog(
//                       //     context: context,
//                       //     builder: (BuildContext context) {
//                       //       Widget dialog = ChangeStaffDialog(
//                       //           currentStaff: state.currentStaff!,
//                       //           availableStaff: b.session.presentStaff);
//                       //       return BlocProvider<SessionBloc>.value(
//                       //           value: b, child: dialog);
//                       //     }).then((value) {
//                       //   if (null != value) {
//                       //     context
//                       //         .read<ApplicationCubit>()
//                       //         .setStaffMember(value as PocStaff);
//                       //     Navigator.pop(context);
//                       //   }
//                       // });
//                     },
//                     child: Center(
//                       child: Container(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 6.0),
//                           child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 state.staffProfile?.avatarWidget() ??
//                                     Container()
//                               ]),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(
//                 width: 18.0,
//               ),
//               // IconButton(
//               //   icon: new Icon(Icons.more_vert),
//               //   color: Colors.grey,
//               //   onPressed: () {
//               //     _showCustomDialog(context);
//               //   },
//               // ),
//             ],
//           ),        
//         endDrawer: widget.endDrawer,
//         endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
//         body: Column(
//           children: <Widget>[
//         //    _buildAppBar(theme, mediaQuery, _k2staffProfile),
//             Expanded(
//               child: widget.buildSafeArea ? SafeArea(top: false, child: widget.body) : widget.body,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}

class LockDetails {
  final int lockId;
  final double accuracy;
  final Proximity proximity;
  final double iosDistance;

  const LockDetails(
      {required this.lockId, required this.accuracy, required this.proximity, this.iosDistance = -1});
}