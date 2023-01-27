part of 'pin_cubit.dart';

enum PinRequestStatus { init, pending, failure, success }

class PinState extends Equatable {
  const PinState({this.pinRequestStatus = PinRequestStatus.init});

  final PinRequestStatus pinRequestStatus;

  PinState copyWith({PinRequestStatus? pinRequestStatus}) {
    return PinState(
      pinRequestStatus: pinRequestStatus ?? PinRequestStatus.init,
    );
  }

  @override
  List<Object?> get props => [pinRequestStatus];
}

class PinInitial extends PinState {}
