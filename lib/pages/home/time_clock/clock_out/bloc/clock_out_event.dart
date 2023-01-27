part of 'clock_out_bloc.dart';

abstract class ClockOutEvent extends Equatable {
  const ClockOutEvent();

  @override
  List<Object?> get props => [];
}

class ClockOutResumeOrBreak extends ClockOutEvent {
  final K2TimeEntry? timeEntry;
  final String? employeeId;
  final String? centerId;
  final String? positionId;
  final K2Shift? shift;
  final String? shiftId;
  final String? scheduleId;
  final K2ClockOutType? startBreak;
  final String type;

  ClockOutResumeOrBreak(
      {required this.timeEntry,
      required this.employeeId,
      required this.centerId,
      required this.positionId,
      this.shift,
      this.shiftId,
      this.scheduleId,
      this.startBreak,
      required this.type});

  @override
  List<Object?> get props => [timeEntry, employeeId, centerId, positionId, shift,
    shiftId, scheduleId, startBreak, type];      
}

class ClockOutRequestedEvent extends ClockOutEvent {
  final K2TimeEntry? timeEntry;
  final K2Shift? shift;
  final String? centerId;

  ClockOutRequestedEvent(
      {required this.timeEntry,
      this.shift,
      this.centerId});

  @override
  List<Object?> get props => [timeEntry, centerId, shift];         
}