import 'package:flutter/material.dart';
import 'package:k2_flutter_api/models/k2_center.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
import 'package:k2_staff/core/widgets/scaffold/staff_app_drawer.dart';
import 'package:k2_staff/pages/home/v2/clock_in/clock_in_screen.dart';
import 'package:k2_staff/pages/home/v2/clock_out/clock_out_screen.dart';
import 'package:k2_staff/pages/home/time_clock/bloc/time_clock_bloc.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_core/constants/constants.dart' as Constants;

class TimeClockHost extends StatelessWidget {
  // const QrClockinScreen(this.id);

  // final int timeStamp = int.parse(QR.params['timestamp'].toString());
  // final String centerId = QR.params['centerid'].toString();

  @override
  Widget build(BuildContext context) {
    final int timestamp =
        int.parse(QR.params[Constants.DEEP_LINK_TIMESTAMP].toString());
    final String centerId = QR.params[Constants.DEEP_LINK_CENTER_ID].toString();
    var sp = context.read<AuthenticationCubit>().state.staffProfile!;

    bool inScope = false;
    if (null != (sp.roleship?.scopes ?? null))
      for (var scope in sp.roleship!.scopes!) {
        if (scope is K2Center) {
          if (scope.id == centerId) {
            inScope = true;
            break;
          }

        }
      }
    
    return !inScope ? 
      Container(
        padding: EdgeInsets.all(24.0),
        child: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('You are not currently affiliated with this center and cannot clock in here.', style: Theme.of(context).textTheme.bodyText2,),
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: ElevatedButton(onPressed: () => QR.to('/home'), child: Text('Return Home')),
          )
        ],
      ),),) : 
      BlocProvider(
        create: (context) =>
            TimeClockBloc(
              employee: context.read<AuthenticationCubit>().state.staffProfile!,
              centerId: centerId,
              timeStamp: timestamp)
              ..add(TimeClockEventScanReceived()),
        child: BlocBuilder<TimeClockBloc, TimeClockState>(
            builder: (context, state) {
              QR.params[Constants.DEEP_LINK_TIMESTAMP]?.keepAlive = false;
              QR.params[Constants.DEEP_LINK_CENTER_ID]?.keepAlive = false;              
              if (state is TimeClockStateTimedOut)
                return Text("Sorry, your QR code has Timed Out");
              else if (state is TimeClockStateClockingOut)
                return ClockOutScreen(
                  centerId: centerId,
                  currentShift: state.shift,
                  openTimeEntry: state.openTimeEntry,
                  timeEntries: state.timeEntries,
                );
                  // openTimeEntry: state.openTimeEntry, 
                  // shift: state.shift, 
                  // logEntries: state.logEntries, 
                  // selectedShift: state.selectedShift);
              else if (state is TimeClockStateClockingIn)
                return ClockInScreen(
                  centerId: centerId,
                  currentShift: state.shift,
                  positions: state.positions,
                  schedule: state.schedule,
                  );
              else 
                return const LoadingScreen();
          // return Column(
          //   children: [
          //     Text(
          //         "TimeStamp: ${DateFormat('hh:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(timeStamp))}"),
          //     Text("CenterId: $centerId")
          //   ],
          // );
        }));
  }
  
}

class LoadingScreen extends StatelessWidget {
  //final String message;
  const LoadingScreen();


  @override
  Widget build(BuildContext context) {

   return KTScaffold(
     drawer: StaffAppDrawer(),
     body: Container(
              width: 425,
              height: 390,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_download, color: Colors.greenAccent, size: 64,),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Text("Loading...", style: Theme.of(context).textTheme.headline1),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:27.0),
                      child: Text(
                          "Looking up your information!"
                          , style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ])),
   );
  }
}
