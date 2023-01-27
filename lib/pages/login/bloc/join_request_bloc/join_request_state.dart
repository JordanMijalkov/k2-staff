import 'package:equatable/equatable.dart';
import 'package:graphql/client.dart';

/// A base JoinRequestState class to extend for the various states of joining an existing business
abstract class JoinRequestState extends Equatable {
  JoinRequestState();
  @override
  List<Object?> get props => [];
}

class JoinRequestStartedState extends JoinRequestState {}
class JoinRequestInValidCenterState extends JoinRequestState {}

/// A JoinRequestState indicating the attached JoinStateEmailInviteCodeStatus
/// needs to follow the Request flow
class JoinStateNeedsRequest extends JoinRequestState {
  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;
  JoinStateNeedsRequest({this.joinStateEmailInviteCodeStatus});
  @override
  List<Object?> get props => [joinStateEmailInviteCodeStatus];
}

class JoinRequestInvitationSentState extends JoinRequestState {
  final QueryResult? response;

  JoinRequestInvitationSentState(this.response);
}

/// A JoinRequestState indicating the attached JoinStateEmailInviteCodeStatus
/// has an Invite flow to follow
class JoinStateHasInvitation extends JoinRequestState {
  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;
  JoinStateHasInvitation({this.joinStateEmailInviteCodeStatus});
  @override
  List<Object?> get props => [joinStateEmailInviteCodeStatus];
}

/// A JoinRequestState that has the validity status on an email inviteCode.
/// This contains all the information we need to know for the flow
class JoinStateEmailInviteCodeStatus extends JoinRequestState {
  final String? email;
  final String? inviteCode;
  final bool? isInviteCodeVerified;
  final bool? isEmailVerified;
  final String? personFirstName;
  final String? personLastName;
  JoinStateEmailInviteCodeStatus({this.email, this.inviteCode, this.isInviteCodeVerified, this.isEmailVerified, this.personFirstName, this.personLastName});

  JoinStateEmailInviteCodeStatus updateWith({required String fName, required String lName}) {
    return JoinStateEmailInviteCodeStatus(
      email: this.email,
      inviteCode: this.inviteCode,
      isInviteCodeVerified: this.isInviteCodeVerified,
      isEmailVerified: this.isEmailVerified,
      personFirstName: fName,
      personLastName: lName
    );
  }
}
