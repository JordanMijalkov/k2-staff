import 'dart:async';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:logging/logging.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService = GetIt.instance<CognitoService>();
  final AuthenticationCubit authBloc;
  LoginBloc({required this.authBloc}) : super(LoginStateDefault()) {
    on<LoginEvent>(_onEvent);
  }
//  : assert(authBloc != null);

  final MessageService? messageService = app<MessageService>();
  final HoneycombService honeycombService = app<HoneycombService>();

  void _onEvent(LoginEvent event, Emitter<LoginState> emit) {
    if (event is LoginEventLoginRequested) return _onLoginEventLoginRequested(event, emit);
    if (event is LoginEventSSOLoginRequest) return _onLoginEventSSOLoginRequest(event, emit);
    if (event is LoginEventSSOLoginTokenReceived) return _onLoginEventSSOLoginTokenReceived(event, emit);
    if (event is LoginEventSSOLoginFailed) return _onLoginEventSSOLoginFailed(event, emit);
    if (event is LoginEventForgotPassword) return _onLoginEventForgotPassword(event, emit);
    if (event is LoginEventDefaultLoginRequest) return _onLoginEventDefaultLoginRequest(event, emit);
    if (event is LoginEventJoinFromRequestState) return _onLoginEventJoinFromRequestState(event, emit);
    if (event is LoginEventChangePasswordCodeSent) return _onLoginEventChangePasswordCodeSent(event, emit);
  }

  void _onLoginEventLoginRequested(
    LoginEventLoginRequested event,
    Emitter<LoginState> emit,
  ) async {
       messageService!.dismiss();
          
          final _event = event as LoginEventLoginRequested;
          final Logger _log = Logger('Log In Event');

          List pairs = [];

          pairs.add({'username', event.username});
          HoneycombEvent he = honeycombService.createEvent('login', 'root', pairs, null);

          emit(LoginStateLoading());


          try {
            final _user = await authService.authActionLogIn(
                username: _event.username, password: _event.password);

            he.closeHoneyCombEvent();

            if (_user != null) {
             // messageService.show("Login Successful!");
              authBloc.logInUser(_user);
              emit(LoginStateDefault());
            } else {
              messageService!.show("Something went wrong...", isSticky: true);
              _log.severe("Something went wrong logging in....");
              emit(LoginStateFailure(error: "Uh Oh 😬 is null!"));
            }
          } on CognitoClientException catch (error, stacktrace) {

            honeycombService.logWarning(error.toString(), pairs);
            messageService!.show("Invalid username or password", isSticky: true);
            _log.warning("Invalid username or password");

            // await CoreRepository.instance.sentryService
            //     .reportError(error, stacktrace);
            emit(LoginStateFailure(error: "Invalid username or password"));
          } on Exception catch (error, stacktrace) {

            honeycombService.logError(error.toString(), stacktrace, pairs);
            messageService!.show("Something went wrong...", isSticky: true);
            _log.severe("Something went wrong logging in....");
            // await CoreRepository.instance.sentryService
            //     .reportError(error, stacktrace);
            emit(LoginStateFailure(error: error.toString()));
          }
  }

  void _onLoginEventSSOLoginRequest(
    LoginEventSSOLoginRequest event,
    Emitter<LoginState> emit,
  ) async {
      emit(LoginStateSSOLogin());
  }

    void _onLoginEventSSOLoginTokenReceived(
    LoginEventSSOLoginTokenReceived _event,
    Emitter<LoginState> emit,
  ) async {
      try {
            K2User _user = await (authService.authActionUserFromTokens(
                _event.idToken, _event.accessToken) as FutureOr<K2User>);
            CognitoUserSession _userSession = await (_user.getSession() as FutureOr<CognitoUserSession>);
            if (_userSession.isValid()) {
              authBloc.logInUser(_user);
            } else {
              emit(LoginStateSSOFailure(
                  error: 'Tokens received via SSO are not valid!'));
            }
          } on Exception catch (error, stacktrace) {
            // await GetIt.instance<SentryService>()
            //     .reportError(error, stacktrace);
            emit(LoginStateSSOFailure(error: error.toString()));
          }
  }

    void _onLoginEventSSOLoginFailed(
    LoginEventSSOLoginFailed _event,
    Emitter<LoginState> emit,
  ) async {
      emit(LoginStateSSOFailure(error: _event.error));
  }

    void _onLoginEventForgotPassword(
    LoginEventForgotPassword event,
    Emitter<LoginState> emit,
  ) async {
      emit(LoginStateForgotPassword());
  }

    void _onLoginEventDefaultLoginRequest(
    LoginEventDefaultLoginRequest event,
    Emitter<LoginState> emit,
  ) async {
      emit(LoginStateDefault());
  }

    void _onLoginEventJoinFromRequestState(
    LoginEventJoinFromRequestState _event,
    Emitter<LoginState> emit,
  ) async {
      final firstName =
              _event.joinStateEmailInviteCodeStatus!.personFirstName;
          final lastName = _event.joinStateEmailInviteCodeStatus!.personLastName;
          if (firstName != null && lastName != null) {
            emit(LoginStateConfirmInviteName(
                joinStateEmailInviteCodeStatus:
                    _event.joinStateEmailInviteCodeStatus));
          } else {
            emit(LoginStateGetInviteName(
                joinStateEmailInviteCodeStatus:
                    _event.joinStateEmailInviteCodeStatus));
          }
  }

    void _onLoginEventChangePasswordCodeSent(
    LoginEventChangePasswordCodeSent _event,
    Emitter<LoginState> emit,
  ) async {
      emit(LoginStateForgotPasswordConfirmationRequired(
              username: _event.username));
  }


  // @override
  // Stream<LoginState> mapEventToState(LoginEvent event) async* {
  //   switch (event.runtimeType) {

  //     // This will attempt (Default) login
  //     case LoginEventLoginRequested:
  //       {
  //         messageService!.dismiss();
          
  //         final _event = event as LoginEventLoginRequested;
  //         final Logger _log = Logger('Log In Event');

  //         List pairs = [];

  //         pairs.add({'username', event.username});
  //         HoneycombEvent he = honeycombService.createEvent('login', 'root', pairs, null);

  //         yield LoginStateLoading();


  //         try {
  //           final _user = await authService.authActionLogIn(
  //               username: _event.username, password: _event.password);

  //           he.closeHoneyCombEvent();

  //           if (_user != null) {
  //            // messageService.show("Login Successful!");
  //             authBloc.logInUser(_user);
  //             yield LoginStateDefault();
  //           } else {
  //             messageService!.show("Something went wrong...", isSticky: true);
  //             _log.severe("Something went wrong logging in....");
  //             yield LoginStateFailure(error: "Uh Oh 😬 is null!");
  //           }
  //         } on CognitoClientException catch (error, stacktrace) {

  //           honeycombService.logWarning(error.toString(), pairs);
  //           messageService!.show("Invalid username or password", isSticky: true);
  //           _log.warning("Invalid username or password");

  //           // await CoreRepository.instance.sentryService
  //           //     .reportError(error, stacktrace);
  //           yield LoginStateFailure(error: "Invalid username or password");
  //         } on Exception catch (error, stacktrace) {

  //           honeycombService.logError(error.toString(), stacktrace, pairs);
  //           messageService!.show("Something went wrong...", isSticky: true);
  //           _log.severe("Something went wrong logging in....");
  //           // await CoreRepository.instance.sentryService
  //           //     .reportError(error, stacktrace);
  //           yield LoginStateFailure(error: error.toString());
  //         }
  //         break;
  //       }

  //     // This will show the Sign In with SSO Screen
  //     case LoginEventSSOLoginRequest:
  //       {
  //         yield LoginStateSSOLogin();
  //         break;
  //       }

  //     case LoginEventSSOLoginTokenReceived:
  //       {
  //         final _event = event as LoginEventSSOLoginTokenReceived;
  //         try {
  //           K2User _user = await (authService.authActionUserFromTokens(
  //               _event.idToken, _event.accessToken) as FutureOr<K2User>);
  //           CognitoUserSession _userSession = await (_user.getSession() as FutureOr<CognitoUserSession>);
  //           if (_userSession.isValid()) {
  //             authBloc.logInUser(_user);
  //           } else {
  //             yield LoginStateSSOFailure(
  //                 error: 'Tokens received via SSO are not valid!');
  //           }
  //         } on Exception catch (error, stacktrace) {
  //           // await GetIt.instance<SentryService>()
  //           //     .reportError(error, stacktrace);
  //           yield LoginStateSSOFailure(error: error.toString());
  //         }

  //         break;
  //       }

  //     case LoginEventSSOLoginFailed:
  //       {
  //         final _event = event as LoginEventSSOLoginFailed;
  //         yield LoginStateSSOFailure(error: _event.error);
  //         break;
  //       }

  //     case LoginEventForgotPassword:
  //       {
  //         yield LoginStateForgotPassword();
  //         break;
  //       }

  //     case LoginEventDefaultLoginRequest:
  //       {
  //         yield LoginStateDefault();
  //         break;
  //       }

  //     case LoginEventJoinFromRequestState:
  //       {
  //         final _event = event as LoginEventJoinFromRequestState;
  //         final firstName =
  //             _event.joinStateEmailInviteCodeStatus!.personFirstName;
  //         final lastName = _event.joinStateEmailInviteCodeStatus!.personLastName;
  //         if (firstName != null && lastName != null) {
  //           yield LoginStateConfirmInviteName(
  //               joinStateEmailInviteCodeStatus:
  //                   _event.joinStateEmailInviteCodeStatus);
  //         } else {
  //           yield LoginStateGetInviteName(
  //               joinStateEmailInviteCodeStatus:
  //                   _event.joinStateEmailInviteCodeStatus);
  //         }
  //         break;
  //       }

  //     case LoginEventChangePasswordCodeSent:
  //       {
  //         final _event = event as LoginEventChangePasswordCodeSent;
  //         yield LoginStateForgotPasswordConfirmationRequired(
  //             username: _event.username);
  //         break;
  //       }
  //   }
  // }
}
