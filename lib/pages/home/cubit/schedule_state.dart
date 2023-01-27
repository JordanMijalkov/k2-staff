part of 'schedule_cubit.dart';

enum ScheduleStateStatus { initializing, initialized }
class ScheduleState extends Equatable {
  const ScheduleState({
    this.status = ScheduleStateStatus.initializing,
    this.timeEntries,
    this.timeOffs,
    this.shifts,
    this.attendance
  });

  final ScheduleStateStatus status;
  final List<K2TimeEntry>? timeEntries;
  final List<K2TimeOffRequest>? timeOffs;
  final Map<DateTime, List<K2Shift>>? shifts;
  final List<K2MyAttendance>? attendance;

  ScheduleState copyWith({
    ScheduleStateStatus? status,
    List<K2TimeEntry>? timeEntries,
    List<K2TimeOffRequest>? timeOffs,
    Map<DateTime, List<K2Shift>>? shifts,
    List<K2MyAttendance>? attendance
  }) {
    return ScheduleState(
      status: status ?? this.status,
      timeEntries: timeEntries ?? this.timeEntries,
      timeOffs: timeOffs ?? this.timeOffs,
      shifts: shifts ?? this.shifts,
      attendance: attendance ?? this.attendance,
    );
  }

  @override
  List<Object?> get props => [status, timeEntries, timeOffs, shifts, attendance];
}


