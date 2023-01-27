part of 'clock_in_bloc.dart';

abstract class ClockInState extends Equatable {
  const ClockInState();
  
  @override
  List<Object?> get props => [];
}

class ClockInInitial extends ClockInState {}

class ClockInSelectPosition extends ClockInState {
  final Map<String?,K2Position> positions;

  ClockInSelectPosition({required this.positions});

    @override
  List<Object?> get props => [positions];    
}

class ClockInNoPositionsError extends ClockInState {}

extension SelectPersonStateExtention on ClockInState {
  bool get isClockInInitial => this is ClockInInitial;
  bool get isClockInSelectPosition => this is ClockInSelectPosition;
  bool get isClockInNoPositionsError => this is ClockInNoPositionsError;

}