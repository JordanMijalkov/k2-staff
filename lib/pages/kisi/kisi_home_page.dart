import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'package:k2_flutter_api/models/k2_kisi_lock.dart';
import 'package:k2_staff/bloc/kisi/kisi_cubit.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';

// class KisiHostPage extends StatelessWidget {
//   const KisiHostPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => KisiCubit(),
//       child: KisiHomePage(),
//     );
//   }
// }

class KisiHomePage extends StatefulWidget {
  KisiHomePage({Key? key, required this.fromWhere}) : super(key: key);
  final String fromWhere;
  @override
  _KisiHomePageState createState() => _KisiHomePageState();
}

class _KisiHomePageState extends State<KisiHomePage> {
  final HoneycombService honeycombService = app<HoneycombService>();

  @override
  void initState() {
    super.initState();
    _rangeLocks();
  }

  @override
  void dispose() {
//    context.read<KisiCubit>().close();
    super.dispose();
  }

  _rangeLocks() async {
    await context.read<KisiCubit>().initLocks();
    await context.read<KisiCubit>().ranging();
  }

  List<K2KisiLock> availableLocks = []; // currently available locks
  Map<int, K2KisiLock> lockLookUp = {};
  List<int> lookUpBlock = []; // reference so we don't slam the api

  Future<List<K2KisiLock>> _parseBeacons(List<Beacon> beacons) async {
    // beacons.forEach((beacon) async {
    //       int lockId = context
    //           .read<KisiCubit>()
    //           .getLockIdFromPair(beacon.major, beacon.minor);
    // }

    //  if (beacons.length != availableLocks.length) {
    honeycombService.logWarning('beacons-found', [
      {'count', beacons.length}
    ]);
    List<K2KisiLock> _availableLocks = [];
    beacons.forEach((beacon) async {
      int lockId = context
          .read<KisiCubit>()
          .getLockIdFromPair(beacon.major, beacon.minor);

      if (!lookUpBlock.contains(lockId)) {
        lookUpBlock.add(lockId);
        honeycombService.logWarning('lock-lookup', [
          {'lockid', lockId.toString()}
        ]);
        var lock = (await context.read<KisiCubit>().getLockFromId(lockId)).lock;
        lockLookUp.putIfAbsent(lockId, () => lock);
        honeycombService.logWarning('lock-lookup-found', [
          {'id', lock.id},
          {'centerid', lock.centerId},
          {'lockid', lock.lockId.toString()},
          {'hasPermissionToUnlock', lock.hasPermissionToUnlock.toString()},
        ]);
        if (lock.hasPermissionToUnlock ?? false)
          _availableLocks.add(lockLookUp[lockId]!);
      } else {
        if (lockLookUp.containsKey(lockId)) if ((lockLookUp[lockId]!
                    .hasPermissionToUnlock ??
                false) &&
            !_availableLocks.contains(lockLookUp[lockId]))
          _availableLocks.add(lockLookUp[lockId]!);
      }
    });
    return _availableLocks;

    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   setState(() {
    //     availableLocks = _availableLocks;
    //   });
    // });
    // }
    // else return [];
  }

  String lockMessage = "Locked";
  Color primaryColor = Colors.pink[50]!;
  Color textColor = Color(0xffc33030);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    double _width = _size.width * .5;
    double _height = _size.height * .7;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _width = _size.width * .8;
      _height = _size.height * .6;
    }

    return KTScaffold(
            showLeading: widget.fromWhere == 'menu' ? true : false,
            body: SafeArea(
                child: Center(
                    child: Container(
                        width: _width,
                        height: _height,
                        child: Column(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: header(),
                          ),
                          BlocBuilder<KisiCubit, KisiState>(
                            builder: (context, state) {
                              if (state.beacons.isEmpty)
                                return Text(
                                  "no locks found....searching",
                                );
                              else {
                                return FutureBuilder(
                                    future: _parseBeacons(state.beacons),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        if (availableLocks.length > 0) {
                                          return locks();
                                        } else
                                          return Text(
                                            "no locks found....searching",
                                          );
                                      } else {
                                        availableLocks =
                                            (snapshot.data as List<K2KisiLock>);
                                        return locks();
                                      }
                                    });
                              }
                            },
                          )
                        ])))));
  }

  Widget locks() {
    return ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
        itemCount: availableLocks.length,
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(index == 0 ? 6 : 0),
                bottom:
                    Radius.circular(index == availableLocks.length - 1 ? 6 : 0),
              ),
            ),
            child: InkWell(
              splashColor: Colors.blue,
              highlightColor: Colors.transparent,
              // onTapDown: (d) =>
              //     selectItem(true),
              // onTapCancel: () =>
              //   selectItem(false),
              onTap: () async {
                setState(() {
                  lockMessage = "Unlocked";
                  primaryColor = Colors.green[200]!;
                  textColor = Colors.green[900]!;
                });
                context
                    .read<KisiCubit>()
                    .unlockKisiDoor(availableLocks[index].lockId!, 0);

                await Future.delayed(const Duration(seconds: 5));
                if (mounted) {
                  setState(() {
                    lockMessage = "Locked";
                    primaryColor = Colors.pink[50]!;
                    textColor = Color(0xffc33030);
                  });
                }
                //    selectItem(false);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  // border: Border.all(
                  // 	color: Color(0x28513c5e),
                  // 	width: 1,
                  // ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33513c5e),
                      offset: Offset(0, 2),
                      blurRadius: 2,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        availableLocks[index].description ?? '',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Text(lockMessage,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: textColor,
                                        fontWeight: FontWeight.w700)),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0x28513c5e),
                                    width: 1,
                                  ),
                                  color: Colors.white,
                                  shape: BoxShape.circle),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.lock_clock, color: textColor),
                              )))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget header() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Nearby Door Locks',
                        style: Theme.of(context).textTheme.headline3))),
            Divider()
          ],
        ),
      ],
    );
  }
}
