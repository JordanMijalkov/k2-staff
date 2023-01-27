import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/colors.dart';
import 'package:k2_staff/core/widgets/clock_icon.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
import 'package:k2_staff/pages/home/v2/clock_in/position_list_widget.dart';
import 'package:k2_staff/pages/home/v2/clock_in/schedule_dialog.dart';
import 'package:k2_staff/pages/home/v2/cubit/staff_cubit.dart';

import 'package:qlevar_router/qlevar_router.dart';
import 'package:intl/intl.dart';

class ClockInScreen extends StatelessWidget {
  ClockInScreen({
    required this.centerId, 
    this.currentShift,
    this.positions,
    this.schedule,
    Key? key}) : super(key: key);

  final String centerId;
  final K2Shift? currentShift;
  final List<K2Position>? positions;
  final List<K2Shift>? schedule;

  final DateFormat timeFormatter = new DateFormat('hh:mm:ss a');

  @override
  Widget build(BuildContext context) {
    K2StaffProfile me = context.read<AuthenticationCubit>().state.staffProfile!;

    final _size = MediaQuery.of(context).size;

    double width = min(460, _size.width*.90);
    int _minutes = 0;

    if (null != currentShift)  
      _minutes = DateTime.parse(currentShift!.startTime!).toLocal()
          .difference(DateTime.now())
          .inMinutes;

      print ('minutes: $_minutes');

    return BlocProvider(
      create: (_) => StaffCubit(
        centerId: this.centerId,
        staffMember: me,
        currentShift: currentShift,
        positions: positions),
      child: Builder(
        builder: (context) {
          return KTScaffold(
            backgroundColor: Colors.grey[200],
              showIcon: true,
              title: "",
              body: Center(
                child: Wrap(children: [
                  Column(
                    children: [
                      Container(
                          width: 500,
                          // padding: const EdgeInsets.symmetric(vertical: 60.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                color: Colors.transparent // Theme.of(context).colorScheme.onSurface,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                          child: BlocBuilder<StaffCubit, StaffState>(
                            builder: (context, state) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "Clock In",
                                      style: Theme.of(context).textTheme.headline1,
                                    ),
                                    SizedBox(
                                      height: 18,
                                    ),
                                    ClockIcon(),
                                    SizedBox(
                                      height: 48,
                                    ),

                                    PositionListWidget(width: width, positions: state.positions),

                                    SizedBox(
                                      height: 24,
                                    ),
                                    SizedBox(
                                        height: 40,
                                        width: width,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              QR.navigator.replaceAll('/home');
                                            },
                                            child: Text(
                                              'Cancel',
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey))),
                                    SizedBox(
                                      height: 48,
                                    ),
                                  ]);
                            },
                          )),

                          schedule!.isNotEmpty
                          ? Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(context: context, 
                                builder: (_) => ScheduleDialog(schedule: schedule!, width: width,)
                                );
                              },
                              child: Container(
                                decoration:
                                  BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.all(Radius.circular(12))),
                                height: 75,
                                width: 500,
                                child: Center(
                                  child: Container(width: width,
                                  height: 50,
                                  decoration:
                                  BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(8))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                        Icon(Icons.calendar_today_outlined, color: Theme.of(context).colorScheme.primary,),
                                        Padding(
                                          padding: const EdgeInsets.only(left:12.0),
                                          child: Text('View Schedule', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                                        )
                                      ],),
                                    )
                                  ),
                                ),
                              ),
                            ),
                          )
                          : Container(),

                      _minutes > 0 
                      ? Padding(
                        padding: const EdgeInsets.only(top:16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.amber[200],
                              border: Border.all(
                                color: Colors.transparent // Theme.of(context).colorScheme.onSurface,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(4))),                          
                          //height: 84,
                          width: 500,
                          
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              children: [
                              Icon(Icons.info_outline),
                              Flexible(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:8.0),
                                      child: Text('You are scheduled to start at ${timeFormatter.format(DateTime.parse(currentShift!.startTime!).toLocal())}.  If you are clocking in early, please contact your supervisor.',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],),
                          ),
                        ),
                      )
                      : Container()
                    ],
                  ),
                ]),
              ));
        }
      ),
    );
  }
}
