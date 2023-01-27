import 'package:equatable/equatable.dart';
import 'package:k2_staff/pages/login/bloc/join_request_bloc/bloc.dart';
abstract class JoinScreenEvent extends Equatable {
  const JoinScreenEvent();
  @override
  List<Object?> get props => [];
}

class NavigateToWelcomePage extends JoinScreenEvent {
  final String? pin;
  final String? password;
  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;

  NavigateToWelcomePage({this.pin, this.password, this.joinStateEmailInviteCodeStatus});
}
class NavigateToCreatePinPage extends JoinScreenEvent {
  final String? password;
  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;

  NavigateToCreatePinPage({required this.joinStateEmailInviteCodeStatus, this.password});
 }
class NavigateToNamePage extends JoinScreenEvent {
  final String? firstname;
  final String? lastname;
  final JoinStateEmailInviteCodeStatus joinStateEmailInviteCodeStatus;

  NavigateToNamePage({required this.joinStateEmailInviteCodeStatus, this.firstname, this.lastname});

  @override
  List<Object?> get props => [firstname, lastname];

 }

 class NavigateToCreatePasswordPage extends JoinScreenEvent {
  final String? firstname;
  final String? lastname;
  final JoinStateEmailInviteCodeStatus joinStateEmailInviteCodeStatus;

  NavigateToCreatePasswordPage({this.firstname, this.lastname, required this.joinStateEmailInviteCodeStatus});

  @override
  List<Object?> get props => [firstname, lastname];

 }
