import 'dart:async';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:k2_flutter_api/repository/authorization/auth_service.dart';
import 'package:k2_flutter_api/repository/authorization/cognito_auth_service.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {

  ForgotPasswordBloc() : super(FPStateInitial()) {
    on<ForgotPasswordEvent>(_onEvent);
  }

  final AuthService _authService = app<CognitoService>();

  void _onEvent(ForgotPasswordEvent event, Emitter<ForgotPasswordState> emit) {
    if (event is FPEventSendCodeRequest) return _onFPEventSendCodeRequest(event, emit);
    if (event is FPEventInitialed) return _onFPEventInitialed(event, emit);
  }

  void _onFPEventInitialed(
    FPEventInitialed event,
    Emitter<ForgotPasswordState> emit,
  ) async {
      emit(FPStateInitial());
  }

 void _onFPEventSendCodeRequest(
    FPEventSendCodeRequest event,
    Emitter<ForgotPasswordState> emit,
  ) async {
      emit(FPStateSendingCode());
 try {
        await _authService
            .authActionSendForgotPasswordEmail(event.email);
        emit(FPStateCodeSent(email: event.email));
      } on CognitoClientException catch (err) {
        emit(FPStateCodeSentError(error: err.message));
      } on Exception catch (err) {
        emit(FPStateCodeSentError(error: err.toString()));
      } catch (_) {
        emit(FPStateCodeSentError(error: 'Something went terribly wrong'));
      }      
  }

  // @override
  // Stream<ForgotPasswordState> mapEventToState(
  //     ForgotPasswordEvent event) async* {
  //   if (event is FPEventSendCodeRequest) {
  //     yield FPStateSendingCode();
  //     try {
  //       await _authService
  //           .authActionSendForgotPasswordEmail(event.email);
  //       yield FPStateCodeSent(email: event.email);
  //     } on CognitoClientException catch (err) {
  //       yield FPStateCodeSentError(error: err.message);
  //     } on Exception catch (err) {
  //       yield FPStateCodeSentError(error: err.toString());
  //     } catch (_) {
  //       yield FPStateCodeSentError(error: 'Something went terribly wrong');
  //     }
  //   }

  //   if (event is FPEventInitialed) {
  //     yield FPStateInitial();
  //   }
  // }
}
