import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:graphql/client.dart';
import 'package:k2_flutter_api/api/core_api_service.dart';
import 'package:k2_flutter_api/api/k2_core_api_client.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/login/bloc/join_request_bloc/bloc.dart';
import 'join_request_event.dart';
import 'join_request_state.dart';
//import 'join_state.dart';

class JoinRequestBloc extends Bloc<JoinRequestEvent, JoinRequestState> {
  JoinRequestBloc() : super(JoinRequestStartedState()) {
    on<JoinRequestEvent>(_onEvent);
  }

  final CoreApiService coreApiService = app<K2CoreApiClient>();

  void _onEvent(JoinRequestEvent event, Emitter<JoinRequestState> emit) {
    if (event is JoinEventInitialState) return _onJoinEventInitialState(event, emit);
    if (event is JoinEventCheckEmailInviteCode) return _onJoinEventCheckEmailInviteCode(event, emit);
    if (event is JoinEventSubmitEmailCode) return _onJoinEventSubmitEmailCode(event, emit);
    if (event is JoinEventSubmitName) return _onJoinEventSubmitName(event, emit);
  }

    void _onJoinEventInitialState(
    JoinEventInitialState event,
    Emitter<JoinRequestState> emit,
  ) async {
      emit(JoinRequestStartedState());
  }

    void _onJoinEventCheckEmailInviteCode(
    JoinEventCheckEmailInviteCode _event,
    Emitter<JoinRequestState> emit,
  ) async {
              final response = await coreApiService.checkEmailInviteCode(email: _event.email, inviteCode: _event.inviteCode);
        bool isEmailValid = response.data!['checkInviteCodeEmailCombo']['emailValid'] || false;
        bool isCodeValid = response.data!['checkInviteCodeEmailCombo']['inviteValid'] || false;
        String? personFirstName = response.data!['checkInviteCodeEmailCombo']['personFirstName'];
        String? personLastName = response.data!['checkInviteCodeEmailCombo']['personLastName'];
        emit(JoinStateEmailInviteCodeStatus(
            email: _event.email,
            inviteCode: _event.inviteCode,
            isEmailVerified: isEmailValid,
            isInviteCodeVerified: isCodeValid,
            personFirstName: personFirstName,
            personLastName: personLastName
        ));

  }

    void _onJoinEventSubmitEmailCode(
    JoinEventSubmitEmailCode _event,
    Emitter<JoinRequestState> emit,
  ) async {
      if (_event.joinStateEmailInviteCodeStatus.isEmailVerified!) {
            // We have an outstanding invite
            emit(JoinStateHasInvitation(
                joinStateEmailInviteCodeStatus: _event.joinStateEmailInviteCodeStatus
            ));
          } else {
            // We need to request to join
            // TODO cancel here needs to revert the join state flow to initial
            emit(JoinStateNeedsRequest(
                joinStateEmailInviteCodeStatus: _event.joinStateEmailInviteCodeStatus
            ));
          }
  }

      void _onJoinEventSubmitName(
    JoinEventSubmitName _event,
    Emitter<JoinRequestState> emit,
  ) async {
      final firstName = _event.joinStateEmailInviteCodeStatus.personFirstName!;
          final lastName = _event.joinStateEmailInviteCodeStatus.personLastName!;
          final inviteCode = _event.joinStateEmailInviteCodeStatus.inviteCode!;
          final email = _event.joinStateEmailInviteCodeStatus.email!;
          // package everything up and send the invitation in
          final QueryResult? response = await (coreApiService.joinByRequest(inviteCode, email, firstName, lastName) as FutureOr<QueryResult?>);
          emit(JoinRequestInvitationSentState(response));
  }

  // @override
  // Stream<JoinRequestState> mapEventToState(
  //   JoinRequestEvent event,
  // ) async* {
  //   switch (event.runtimeType) {

  //     case JoinEventInitialState: {
  //       yield JoinRequestStartedState();
  //       break;
  //     }

  //     case JoinEventCheckEmailInviteCode: {
  //       final _event = event as JoinEventCheckEmailInviteCode;
  //       final response = await coreApiService.checkEmailInviteCode(email: _event.email, inviteCode: _event.inviteCode);
  //       bool isEmailValid = response.data!['checkInviteCodeEmailCombo']['emailValid'] || false;
  //       bool isCodeValid = response.data!['checkInviteCodeEmailCombo']['inviteValid'] || false;
  //       String? personFirstName = response.data!['checkInviteCodeEmailCombo']['personFirstName'];
  //       String? personLastName = response.data!['checkInviteCodeEmailCombo']['personLastName'];
  //       yield JoinStateEmailInviteCodeStatus(
  //           email: _event.email,
  //           inviteCode: _event.inviteCode,
  //           isEmailVerified: isEmailValid,
  //           isInviteCodeVerified: isCodeValid,
  //           personFirstName: personFirstName,
  //           personLastName: personLastName
  //       );
  //       break;
  //     }

  //     case JoinEventSubmitEmailCode: {
  //         final _event = event as JoinEventSubmitEmailCode;
  //         if (_event.joinStateEmailInviteCodeStatus.isEmailVerified!) {
  //           // We have an outstanding invite
  //           yield JoinStateHasInvitation(
  //               joinStateEmailInviteCodeStatus: _event.joinStateEmailInviteCodeStatus
  //           );
  //         } else {
  //           // We need to request to join
  //           // TODO cancel here needs to revert the join state flow to initial
  //           yield JoinStateNeedsRequest(
  //               joinStateEmailInviteCodeStatus: _event.joinStateEmailInviteCodeStatus
  //           );
  //         }
  //         break;
  //       }

  //     case JoinEventSubmitName: {
  //         final _event = event as JoinEventSubmitName;
  //         final firstName = _event.joinStateEmailInviteCodeStatus.personFirstName!;
  //         final lastName = _event.joinStateEmailInviteCodeStatus.personLastName!;
  //         final inviteCode = _event.joinStateEmailInviteCodeStatus.inviteCode!;
  //         final email = _event.joinStateEmailInviteCodeStatus.email!;
  //         // package everything up and send the invitation in
  //         final QueryResult? response = await (coreApiService.joinByRequest(inviteCode, email, firstName, lastName) as FutureOr<QueryResult?>);
  //         yield JoinRequestInvitationSentState(response);
  //         break;
  //       }
  //   }
  // }
}
