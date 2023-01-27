// import 'package:equatable/equatable.dart';
// import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';

// abstract class ScheduleState extends Equatable {
//   const ScheduleState();
//   @override
//   List<Object?> get props => [];
// }

// class ScheduleInitial extends ScheduleState {
//   @override
//   List<Object> get props => [];
// }

// class SelectedScheduleState extends ScheduleState {
//   final K2DateTimeRange timeRange;
//   final List<K2TimeEntry?> timeEntries;
//   final List<K2Shift>? shiftSchedule;
// //  final K2User k2user;
//   final K2DateTimeRange? activeDateRange;
//   final List<K2TimeOffRequest>? myTimeOffs;

//   SelectedScheduleState(this.timeRange, this.timeEntries,
//       {this.shiftSchedule, this.activeDateRange, this.myTimeOffs});

//   SelectedScheduleState updateWith(
//       {List<K2Shift>? shiftSchedule,
//       K2DateTimeRange? activeDateRange,
//       List<K2TimeOffRequest>? myTimeOffs}) {
//     return SelectedScheduleState(this.timeRange, this.timeEntries,
//         shiftSchedule: shiftSchedule ?? this.shiftSchedule,
//         activeDateRange: activeDateRange ?? this.activeDateRange,
//         myTimeOffs: myTimeOffs ?? this.myTimeOffs);
//   }

//   @override
//   List<Object?> get props => [
//         timeRange,
//         timeEntries,
//         shiftSchedule,
//        // k2user,
//         activeDateRange,
//         myTimeOffs
//       ];
// }
