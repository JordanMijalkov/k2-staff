part of 'profile_screen_cubit.dart';

enum RequestStatus { init, pending, loading, success, failure }
enum ProfileScreenStatus { initializing, complete }

class ProfileScreenState extends Equatable {
  const ProfileScreenState({
    this.emergencyContacts = const[],
    this.profileSaveStatus = RequestStatus.init,
    this.screenStatus = ProfileScreenStatus.initializing,
    this.passwordChangeStatus = RequestStatus.init
  });

  final List<EmergencyContact> emergencyContacts;
  final RequestStatus profileSaveStatus;
  final ProfileScreenStatus screenStatus;
  final RequestStatus passwordChangeStatus;

  ProfileScreenState copyWith(
      {
        List<EmergencyContact>? emergencyContacts,
        RequestStatus? profileSaveStatus,
        ProfileScreenStatus? screenStatus,
        RequestStatus? passwordChangeStatus
      }) {
    return ProfileScreenState(
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      profileSaveStatus: profileSaveStatus ?? this.profileSaveStatus,
      screenStatus: screenStatus ?? this.screenStatus,
      passwordChangeStatus: passwordChangeStatus ?? this.passwordChangeStatus,
    );
  }

  @override
  List<Object> get props => [emergencyContacts, profileSaveStatus, screenStatus, passwordChangeStatus];
}

