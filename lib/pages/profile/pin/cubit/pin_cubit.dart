import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'package:k2_staff/core/services/service_locator.dart';


part 'pin_state.dart';

class PinCubit extends Cubit<PinState> {
  PinCubit() : super(PinInitial());

  final CoreApiService coreApiService = app<K2CoreApiClient>();
    final AuthService _authService = app<CognitoService>();

  Future<void> updatePIN(String staffId, String newPin) async {
    emit(state.copyWith(pinRequestStatus: PinRequestStatus.pending));

    try {
      final _result = await coreApiService.updateStaffPin(staffId, newPin);
      if (null == _result || _result.hasException) {
            emit(state.copyWith(pinRequestStatus: PinRequestStatus.failure));
          }
      else {
            emit(state.copyWith(pinRequestStatus: PinRequestStatus.success));
          }
    } on Exception {
      emit(state.copyWith(pinRequestStatus: PinRequestStatus.failure));
    }
  }
}
