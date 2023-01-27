import 'package:equatable/equatable.dart';
import 'package:k2_staff/pages/login/bloc/join_request_bloc/bloc.dart';

abstract class JoinScreenState extends Equatable {
  const JoinScreenState();
  @override
  List<Object> get props => [];
}

//class JoinScreenInitial extends JoinScreenState { }

class JoinScreenGetNameState extends JoinScreenState {
  final String? firstname;
  final String? lastname;

  JoinScreenGetNameState({this.firstname, this.lastname});

  @override
  List<Object> get props => [];
}

class JoinScreenGetPasswordState extends JoinScreenState {
  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;

  JoinScreenGetPasswordState({this.joinStateEmailInviteCodeStatus});

}

class JoinScreenGetPinState extends JoinScreenState {
  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;
  final String? password;

  JoinScreenGetPinState({this.joinStateEmailInviteCodeStatus, this.password});
}
class JoinScreenWelcomePageState extends JoinScreenState {}
  // final String firstname;
  // final String lastname;

//   JoinScreenGetPassword();

//   @override
//   List<Object> get props => [];
// }
