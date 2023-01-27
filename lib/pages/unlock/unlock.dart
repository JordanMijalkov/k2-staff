import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:k2_flutter_core/widgets/textbox_with_header.dart';
import 'package:k2_staff/bloc/application/application_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_staff/bloc/kisi/kisi_cubit.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
import 'package:k2_staff/core/widgets/scaffold/staff_app_drawer.dart';

class UnlockTest extends StatefulWidget {
  const UnlockTest({Key? key}) : super(key: key);

  @override
  State<UnlockTest> createState() => _UnlockTestState();
}

class _UnlockTestState extends State<UnlockTest> {
  final _usernameController = TextEditingController();
  final Key _userNameKey = GlobalKey(debugLabel: "LockId");
  FocusNode _focusNodeUserName = new FocusNode();
  List<Beacon> beaconList = [];
  
  double _distance(rssiVal) {
//MeasuredPower is a constant defined by the manufacturing of the device
//also known as the 1 Meter RSSI
//-69 (for kontakt BLE beacons)
double measuredPowerConstantDeviceManufacturer = -69;

//N constant depends on the Environmental factor. Range 2-4
double nConstantEnvironmental = 2;

double baseConstant= 10;

//calculation to convert rssi value to a distance in meters
//source: estimo - https://iotandelectronics.wordpress.com/2016/10/07/how-to-calculate-distance-from-the-rssi-value-of-the-ble-beacon/
//calc double distance = 10 ^ ((Measured Power - RSSI)/(10 * N))

double partA = measuredPowerConstantDeviceManufacturer - rssiVal;
double partB = baseConstant * nConstantEnvironmental;
double exponent = ( partA / partB ); 
num distance = pow(baseConstant, exponent);

return double.parse(distance.toStringAsFixed(2));
  }

  @override
  void initState() {
    super.initState();

    // controller.startStream.listen((flag) {
    //   if (flag == true) {

      context.read<KisiCubit>().initLocks();
      context.read<KisiCubit>().ranging();
      
      //checkAllRequirements();
       // scanForBeacons(_k2staffProfile.fullName);

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KisiCubit, KisiState>(
      listenWhen: (previous, current) {
        if (current.status == KisiStatus.rangingDone)
          return true;
        else 
          return false;
      },
      listener: (context, state) {
        setState(() {
          beaconList = state.beacons;
        });
      },
     child: ListView.builder(
                    itemCount: beaconList.length,
                    itemBuilder: (context, index) {
                      double distance = _distance(beaconList[index].rssi);
                      return ListTile(
                        title: Text('Lock ID: ${beaconList[index].major}, ${beaconList[index].minor}'),
                        subtitle: Text('Distance: $distance         Power:${beaconList[index].rssi}'),
                      );
            
                  }));

_usernameController.text = '22162';

        return KTScaffold(
          drawer: StaffAppDrawer(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ListView.builder(
                  //   itemCount: beaconList.length,
                  //   itemBuilder: (context, index) {
                  //     return ListTile(
                  //       title: Text('Lock ID: ${beaconList[index].major}, ${beaconList[index].minor}'),
                  //       subtitle: Text('Proximity: ${beaconList[index].proximity}'),
                  //     );
              
                  // }),
                  TextBoxWithHeader(
                    autoFocus: true,
                    fieldKey: _userNameKey,
                    labelText: "Lock ID",
                    hintText: "12345",
                    // focusNode: _focusNodeUserName,
                    // validator: FormValidators.emailValidator,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: _usernameController,
                    bottomPadding: 16,
                    onFieldSubmitted: (term) {
                      _focusNodeUserName.unfocus();
                    }, 
                  ),
                  SizedBox(
                      height: 40.0,
                      width: 200,
                      child: ElevatedButton(
                          child: Text("Unlock"),
                          onPressed: () {
                            context.read<KisiCubit>().unlockKisiDoor(
                                int.parse(_usernameController.text), 0);
                          })),
                ],
              ),
            ),
          ),
        );
    //   },
    // );
  }

  void _buttonPressed() {}
}
