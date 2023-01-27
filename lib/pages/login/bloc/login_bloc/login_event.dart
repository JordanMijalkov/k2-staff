import 'package:equatable/equatable.dart';
import 'package:k2_staff/pages/login/bloc/join_request_bloc/bloc.dart';
import 'package:meta/meta.dart';

/// A base LoginEvent class to extend for the various events for logging in
abstract class LoginEvent extends Equatable {
  LoginEvent();
  @override
  List<Object> get props => [];
}

/// A LoginEvent indicating that we need to attempt the default login flow
class LoginEventLoginRequested extends LoginEvent {
  final String username;
  final String password;

  LoginEventLoginRequested({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

/// A LoginEvent indicating we need to trigger the Forgot Password flow
class LoginEventForgotPassword extends LoginEvent {}

/// A LoginEvent indicating a password-reset confirmation code has been sent
class LoginEventChangePasswordCodeSent extends LoginEvent {
  final String username;

  LoginEventChangePasswordCodeSent({required this.username});

  @override
  List<Object> get props => [username];
}

/// A LoginEvent indicating we need to trigger the SSO Login flow
class LoginEventSSOLoginRequest extends LoginEvent {}

class LoginEventSSOLoginWebViewRequest extends LoginEvent {
  final String domain;

  LoginEventSSOLoginWebViewRequest({required this.domain});
}

class LoginEventSSOLoginTokenReceived extends LoginEvent {
  final String idToken;
  final String accessToken;

  LoginEventSSOLoginTokenReceived(
      {required this.idToken, required this.accessToken});
}

class LoginEventSSOLoginCodeReceived extends LoginEvent {
  final String code;

  LoginEventSSOLoginCodeReceived({required this.code});
}

/// A LoginEvent indicating we are progressing on the Join Flow
class LoginEventJoinFromRequestState extends LoginEvent {
  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;
  LoginEventJoinFromRequestState({this.joinStateEmailInviteCodeStatus});
}

class LoginEventSSOLoginFailed extends LoginEvent {
  final String error;

  LoginEventSSOLoginFailed({required this.error});
}

/// A LoginEvent indicating we should go back to the default Login flow
class LoginEventDefaultLoginRequest extends LoginEvent {}
