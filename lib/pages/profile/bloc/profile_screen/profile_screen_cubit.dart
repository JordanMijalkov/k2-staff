import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'package:k2_flutter_api/models/k2_staff_profile.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/profile/models/emergency_contact.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit() : super(const ProfileScreenState());

  final CoreApiService coreApiService = app<K2CoreApiClient>();
    final AuthService _authService = app<CognitoService>();

  
  void addAditionalEmergencyContact(EmergencyContact emergencyContact) {
    List<EmergencyContact> emergencyContacts = [
      ...(state.emergencyContacts)
    ]..add(emergencyContact);

    emit(state.copyWith(emergencyContacts: emergencyContacts));


  }

  Future<void> saveProfile(K2StaffProfile k2staffProfile) async {
    emit(state.copyWith(profileSaveStatus: RequestStatus.pending));

   try {
      final _result = await coreApiService.updateMyProfile(k2staffProfile);

    if (null == _result || _result.hasException) {
      emit(state.copyWith(profileSaveStatus: RequestStatus.success));
      }
    else {
        emit(state.copyWith(profileSaveStatus: RequestStatus.success));
      }      
    } on Exception {
      emit(state.copyWith(profileSaveStatus: RequestStatus.failure));
    }
  }

  Future<void> updatePIN(String staffId, String newPin) async {

    emit(state.copyWith(passwordChangeStatus: RequestStatus.pending));

    try {
      final _result = await coreApiService.updateStaffPin(staffId, newPin);
      if (null == _result || _result.hasException) {
            emit(state.copyWith(passwordChangeStatus: RequestStatus.failure));
          }
      else {
            emit(state.copyWith(passwordChangeStatus: RequestStatus.success));
          }
    } on Exception {
      emit(state.copyWith(passwordChangeStatus: RequestStatus.failure));
    }



  }  

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    emit(ProfileScreenState().copyWith(passwordChangeStatus: RequestStatus.pending));

    try {
      final _result = await _authService.changePassword(oldPassword, newPassword);
      if (!_result) {
            emit(state.copyWith(passwordChangeStatus: RequestStatus.failure));
          }
      else {
            emit(state.copyWith(passwordChangeStatus: RequestStatus.success));
          }
    } on Exception {
      emit(state.copyWith(passwordChangeStatus: RequestStatus.failure));
    }

   // if (_)
  }
}
