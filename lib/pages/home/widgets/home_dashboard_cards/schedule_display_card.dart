import 'package:flutter/material.dart';
import 'package:k2_staff/pages/home/bloc/schedule/schedule_state.dart';
import 'package:k2_staff/pages/home/widgets/home_dashboard_cards/schedule.dart';

class ScheduleDisplayCard extends StatelessWidget {
//  final ScheduleState? state;

  const ScheduleDisplayCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ScheduleWidget()
          // if (state.runtimeType == SelectedScheduleState)
          //   ScheduleWidget(
          //     dateRange: (state as SelectedScheduleState).activeDateRange,
          //     shifts: (state as SelectedScheduleState?)?.shiftSchedule,
          //   )
        ]);
  }
}