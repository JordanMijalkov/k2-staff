import 'package:equatable/equatable.dart';
import 'package:k2_staff/pages/login/bloc/join_request_bloc/bloc.dart';
import 'package:meta/meta.dart';

/// A base LoginState class to extend for the various states of logging in
abstract class LoginState extends Equatable {
  LoginState();
  @override
  List<Object> get props => [];
}

/// A LoginState indicating we need to display the Default Login Page
class LoginStateDefault extends LoginState {}

/// A LoginState indicating we need to wait while a LoginAction is being performed
class LoginStateLoading extends LoginState {}

/// A LoginState indicating a failure with the login process
class LoginStateFailure extends LoginState {
  final String error;

  LoginStateFailure({required this.error});

  @override
  List<Object> get props => [error];
}

/// A LoginState indicating we need to display a Forgot Password screen
class LoginStateForgotPassword extends LoginState {}

/// A LoginState indicating we ned to confirm a code + new password
class LoginStateForgotPasswordConfirmationRequired extends LoginState {
  final String username;

  LoginStateForgotPasswordConfirmationRequired({required this.username});

  @override
  List<Object> get props => [username];
}

/// A LoginState indicating we need to display a (required) New/Change Password screen
class LoginStateNewPasswordRequired extends LoginState {}

/// A LoginState indicating we need to start the change password flow
class LoginStatePasswordChangeRequested extends LoginState {}

/// A LoginState indicating we need to display an SSO Login Screen
class LoginStateSSOLogin extends LoginState {}

/// A LoginState indicating we need to display an SSO Login WebView Screen
class LoginStateSSOWebViewLogin extends LoginState {
  final String domain;

  LoginStateSSOWebViewLogin({required this.domain});
}

/// A LoginState indicating we are 'unlocking' a logged in user (via PIN)
class LoginStateSwitchUserRequested extends LoginState {}

/// A LoginState indicating we want to display the Page that
/// confirms an Invited User's name
class LoginStateConfirmInviteName extends LoginState {
  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;
  LoginStateConfirmInviteName({this.joinStateEmailInviteCodeStatus});
}

/// A LoginState  indicating we want to display the Page that
/// acquires a users name for a Request to Join
class LoginStateGetInviteName extends LoginState {
  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;
  LoginStateGetInviteName({this.joinStateEmailInviteCodeStatus});
}

/// A LoginState indicating an unsuccessful SSO Login attempt
class LoginStateSSOFailure extends LoginState {
  final String error;

  LoginStateSSOFailure({required this.error});

  @override
  List<Object> get props => [error];
}
