part of 'clock_in_bloc.dart';

abstract class ClockInEvent extends Equatable {
  const ClockInEvent();

  @override
  List<Object?> get props => [];
}

class ClockInForUnscheduledShift extends ClockInEvent {
  final K2Position? position;
//  final K2Shift shift;

  ClockInForUnscheduledShift({this.position});

  @override
  List<Object?> get props => [position];  
}

class ClockInForScheduledShift extends ClockInEvent {
  final K2Position? position;
  final String type;
//  final String shiftId;
  final String? scheduleId;
  final K2Shift? selectedShift;

  ClockInForScheduledShift(
      {required this.position,
      required this.type,
  //    this.shiftId,
      this.scheduleId,
      this.selectedShift});
}
