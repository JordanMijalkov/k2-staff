part of 'time_clock_bloc.dart';

abstract class TimeClockState extends Equatable {
  const TimeClockState();
  
  @override
  List<Object> get props => [];
}

class TimeClockStateInitial extends TimeClockState { }
class TimeClockWorking extends TimeClockState {}

class TimeClockStateTimedOut extends TimeClockState { } 

class TimeClockStateClockingOut extends TimeClockState{
  final K2TimeEntry? openTimeEntry;
  final K2Shift? selectedShift;
  final K2Shift? shift;
  final List<K2TimeEntrySummaryItem>? timeEntries;

  TimeClockStateClockingOut({this.openTimeEntry, this.selectedShift, this.shift, this.timeEntries});
}

class TimeClockStateClockingIn extends TimeClockState {
  final K2Shift? shift;
  final List<K2Position> positions;
  final List<K2Shift> schedule;

  TimeClockStateClockingIn(this.shift, this.positions, this.schedule);
}
  // final bool isAuthenticated;
  // TimeClockStateInitial({@required this.isAuthenticated})

