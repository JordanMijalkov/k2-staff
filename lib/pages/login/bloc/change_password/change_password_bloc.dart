import 'dart:async';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {

  ChangePasswordBloc() : super(ChangePasswordStateDefault()) {
    on<ChangePasswordEvent>(_onEvent);
  }

  final AuthService _authService = app<CognitoService>();

  void _onEvent(ChangePasswordEvent event, Emitter<ChangePasswordState> emit) {
    if (event is ChangePasswordEventRequested) return _onChangePasswordEventRequested(event, emit);
    if (event is ChangePasswordEventConfirmationRequested) return _onChangePasswordEventConfirmationRequested(event, emit);
  }


  void _onChangePasswordEventRequested(
    ChangePasswordEventRequested event,
    Emitter<ChangePasswordState> emit,
  ) async {
      emit(ChangePasswordStateDefault());
  }

  void _onChangePasswordEventConfirmationRequested(
    ChangePasswordEventConfirmationRequested event,
    Emitter<ChangePasswordState> emit,
  ) async {
      emit(ChangePasswordStateLoading());

        try {
          bool _success = await _authService.authActionAttemptPasswordReset(event.username!, event.verificationCode, event.newPassword);
          if (_success) {
            emit(ChangePasswordStateSuccess());
          } else {
            emit(ChangePasswordStateError(error: 'Uh Oh! Please chech you code or password!'));
          }
        } on CognitoClientException catch (error) {
          emit(ChangePasswordStateError(error: error.message));
        } catch (error) {
          emit(ChangePasswordStateError(error: 'Uh Oh! There was an issue confirming your request!'));
        }      
  }

  // @override
  // Stream<ChangePasswordState> mapEventToState(ChangePasswordEvent event) async* {

  //   switch (event.runtimeType) {

  //     case ChangePasswordEventRequested: {
  //       yield ChangePasswordStateDefault();
  //       break;
  //     }

  //     case ChangePasswordEventConfirmationRequested: {
  //       final _event = event as ChangePasswordEventConfirmationRequested;
  //       yield ChangePasswordStateLoading();
  //       try {
  //         bool _success = await _authService.authActionAttemptPasswordReset(_event.username!, _event.verificationCode, _event.newPassword);
  //         if (_success) {
  //           yield ChangePasswordStateSuccess();
  //         } else {
  //           yield ChangePasswordStateError(error: 'Uh Oh! Please chech you code or password!');
  //         }
  //       } on CognitoClientException catch (error) {
  //         yield ChangePasswordStateError(error: error.message);
  //       } catch (error) {
  //         yield ChangePasswordStateError(error: 'Uh Oh! There was an issue confirming your request!');
  //       }
  //       break;
  //     }

  //   }

  // }
}
