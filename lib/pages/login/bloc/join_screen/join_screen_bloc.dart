import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:k2_flutter_api/repository/authorization/auth_service.dart';
import 'package:k2_flutter_api/repository/authorization/cognito_auth_service.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'join_screen_event.dart';
import 'join_screen_state.dart';

class JoinScreenBloc extends Bloc<JoinScreenEvent, JoinScreenState> {
  String? firstname;
  String? lastname;

  final AuthService _authService = app<CognitoService>();
  JoinScreenBloc({this.firstname, this.lastname}) : super(JoinScreenGetNameState(
      firstname: firstname, lastname: lastname)) {
        on<JoinScreenEvent>(_onEvent);
      }

  NewUser newUser = NewUser();

  void _onEvent(JoinScreenEvent event, Emitter<JoinScreenState> emit) {
    if (event is NavigateToCreatePasswordPage) return _onNavigateToCreatePasswordPage(event, emit);
    if (event is NavigateToCreatePinPage) return _onNavigateToCreatePinPage(event, emit);
    if (event is NavigateToWelcomePage) return _onNavigateToWelcomePage(event, emit);
    if (event is NavigateToNamePage) return _onNavigateToNamePage(event, emit);
  }

  void _onNavigateToCreatePasswordPage(
    NavigateToCreatePasswordPage _event,
    Emitter<JoinScreenState> emit,
  ) async {
      emit(JoinScreenGetPasswordState(
              // _event.joinStateEmailInviteCodeStatus should have been updateWith'ed in the form!
              joinStateEmailInviteCodeStatus:
                  _event.joinStateEmailInviteCodeStatus));
  }

  void _onNavigateToCreatePinPage(
    NavigateToCreatePinPage _event,
    Emitter<JoinScreenState> emit,
  ) async {
      newUser.password = _event.password;
          emit(JoinScreenGetPinState(
              password: _event.password,
              joinStateEmailInviteCodeStatus:
                  _event.joinStateEmailInviteCodeStatus));
  }

    void _onNavigateToWelcomePage(
    NavigateToWelcomePage _event,
    Emitter<JoinScreenState> emit,
  ) async {
      try {
            await _authService
                .authActionSignUpFromInvite(
                    email: _event.joinStateEmailInviteCodeStatus!.email,
                    password: _event.password,
                    inviteCode:
                        _event.joinStateEmailInviteCodeStatus!.inviteCode,
                    pin: _event.pin,
                    firstName:
                        _event.joinStateEmailInviteCodeStatus!.personFirstName,
                    lastName:
                        _event.joinStateEmailInviteCodeStatus!.personLastName);
            await _authService.authActionLogIn(
                username: _event.joinStateEmailInviteCodeStatus!.email!,
                password: _event.password!);
          } catch (err) {
            // debugPrint('Error Creating user from invite!');
            // debugPrint(err.toString());
            // TODO what state should this yield if failure?
          }
          emit(JoinScreenWelcomePageState());
  }

    void _onNavigateToNamePage(
    NavigateToNamePage _event,
    Emitter<JoinScreenState> emit,
  ) async {
      newUser.firstname = _event.firstname;
          newUser.lastname = _event.lastname;
          emit(JoinScreenGetNameState(
              firstname: _event.firstname, lastname: _event.lastname));
  }

  // @override
  // JoinScreenState get initialState => JoinScreenGetNameState(
  //     firstname: this.firstname, lastname: this.lastname);

  // @override
  // Stream<JoinScreenState> mapEventToState(
  //   JoinScreenEvent event,
  // ) async* {
  //   switch (event.runtimeType) {
  //     case NavigateToCreatePasswordPage:
  //       {
  //         final _event = event as NavigateToCreatePasswordPage;
  //         yield JoinScreenGetPasswordState(
  //             // _event.joinStateEmailInviteCodeStatus should have been updateWith'ed in the form!
  //             joinStateEmailInviteCodeStatus:
  //                 _event.joinStateEmailInviteCodeStatus);
  //         break;
  //       }
  //     case NavigateToCreatePinPage:
  //       {
  //         final _event = event as NavigateToCreatePinPage;
  //         newUser.password = _event.password;
  //         yield JoinScreenGetPinState(
  //             password: _event.password,
  //             joinStateEmailInviteCodeStatus:
  //                 _event.joinStateEmailInviteCodeStatus);
  //         break;
  //       }
  //     case NavigateToWelcomePage:
  //       {
  //         final _event = event as NavigateToWelcomePage;
  //         // TODO Grab all the info, and send it off here!
  //        // debugPrint('SENDING!');
  //         try {
  //           await _authService
  //               .authActionSignUpFromInvite(
  //                   email: _event.joinStateEmailInviteCodeStatus!.email,
  //                   password: _event.password,
  //                   inviteCode:
  //                       _event.joinStateEmailInviteCodeStatus!.inviteCode,
  //                   pin: _event.pin,
  //                   firstName:
  //                       _event.joinStateEmailInviteCodeStatus!.personFirstName,
  //                   lastName:
  //                       _event.joinStateEmailInviteCodeStatus!.personLastName);
  //           await _authService.authActionLogIn(
  //               username: _event.joinStateEmailInviteCodeStatus!.email!,
  //               password: _event.password!);
  //         } catch (err) {
  //           // debugPrint('Error Creating user from invite!');
  //           // debugPrint(err.toString());
  //           // TODO what state should this yield if failure?
  //         }
  //         yield JoinScreenWelcomePageState();
  //         break;
  //       }
  //     case NavigateToNamePage:
  //       {
  //         final _event = event as NavigateToNamePage;
  //         newUser.firstname = _event.firstname;
  //         newUser.lastname = _event.lastname;
  //         yield JoinScreenGetNameState(
  //             firstname: _event.firstname, lastname: _event.lastname);
  //         break;
  //       }
  //   }
  // }
}

class NewUser {
  String? firstname;
  String? lastname;
  String? password;
  String? pin;
}

//enum JoinScreenState { name, password, code, welcome }
