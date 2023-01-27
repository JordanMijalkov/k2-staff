import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_flutter_api/models/k2_my_attendance.dart';
import 'package:k2_staff/core/colors.dart';
import 'package:k2_staff/pages/home/cubit/schedule_cubit.dart';
import 'package:collection/collection.dart' show IterableExtension;

class ClockStatusCard extends StatelessWidget {
//  final K2TimeEntry? _openTimeEntry;
  final VoidCallback? onTap;

  ClockStatusCard({Key? key, this.onTap}) : super(key: key);
  final DateFormat timeFormatter = new DateFormat('hh:mm:ss a');
  
  @override
  Widget build(BuildContext context) {
    String mainText = "You are not currently Clocked In";
    String subText = "";
//    bool is

    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {

    List<K2MyAttendance> days = state.attendance!;
    for (var center in days) {
      for (var day in center.days!) {
        K2TimeEntry? _openTimeEntry = day.timeEntries!.firstWhereOrNull((element) => element.timeOut == null);
        if (null != _openTimeEntry) {
            DateTime dt = DateTime.parse(_openTimeEntry.timeIn!).toLocal();
            mainText = "You are currently clocked in";
            subText = "Clocked in at ${timeFormatter.format(dt)}";
            break;
        }
      }
     }

    // K2TimeEntry? _openTimeEntry = state.timeEntries!.firstWhereOrNull((element) => element.timeOut == null);
    // var shifts = state.shifts!.keys.toList()..sort();

    // if (_openTimeEntry != null) {
    //   switch (_openTimeEntry.type) {
    //     case 'BREAK':
    //       {
    //         mainText = "You are currently on break!";
    //         subText = "Breaked at ${_openTimeEntry.timeIn}";
    //         break;
    //       }
    //     default:
    //       {
    //         mainText = "You are currently clocked in";
    //         subText = "Clocked in at ${_openTimeEntry.timeIn}";
    //         break;
    //       }
    //   }
    // }


        return InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: K2Colors.success,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Current Status:",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: K2Colors.white)),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            '\t\t$mainText',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: K2Colors.white),
                          ),
                        ),
                        if (subText.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '\t\t$subText',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: K2Colors.white),
                            ),
                          ),

                        // shifts.isEmpty 
                        //   ? Text('You have no scheduled shifts')
                        //   : Text('Next shift is xxxxx')
                      ],
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
