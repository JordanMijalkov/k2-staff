import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:k2_staff/pages/login/bloc/join_request_bloc/bloc.dart';

/// A Base JoinRequestEvent
abstract class JoinRequestEvent extends Equatable {
  const JoinRequestEvent();
  @override
  List<Object> get props => [];
}

/// A JoinRequestEvent indicating we are starting the Join process
class JoinEventInitialState extends JoinRequestEvent {}

/// A JoinRequestEvent indicating we need to submit the provided information
class JoinEventSubmitEmailCode extends JoinRequestEvent {
  final JoinStateEmailInviteCodeStatus joinStateEmailInviteCodeStatus;
  JoinEventSubmitEmailCode(this.joinStateEmailInviteCodeStatus);
  @override
  List<Object> get props => [joinStateEmailInviteCodeStatus];
}

/// A JoinRequestEvent indicating we need to submit the provided information
class JoinEventSubmitName extends JoinRequestEvent {
  final JoinStateEmailInviteCodeStatus joinStateEmailInviteCodeStatus;
  JoinEventSubmitName({required this.joinStateEmailInviteCodeStatus});
}

/// A JoinRequestEvent indicating we need to check if an inviteCode is valid
class JoinEventCheckEmailInviteCode extends JoinRequestEvent {
  final String email;
  final String inviteCode;
  JoinEventCheckEmailInviteCode({required this.email, required this.inviteCode});
}
