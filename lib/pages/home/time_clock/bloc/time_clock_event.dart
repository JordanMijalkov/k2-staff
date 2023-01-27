part of 'time_clock_bloc.dart';

abstract class TimeClockEvent extends Equatable {
  const TimeClockEvent();

  @override
  List<Object> get props => [];
}

class TimeClockEventScanReceived extends TimeClockEvent {}
