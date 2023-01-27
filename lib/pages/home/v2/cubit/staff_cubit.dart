import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'package:k2_staff/core/services/service_locator.dart';

part 'staff_state.dart';

class StaffCubit extends Cubit<StaffState> {
  StaffCubit(
      {required centerId,
      required staffMember,
      required currentShift,
      positions})
      : super(StaffState(
            centerId: centerId,
            staffMember: staffMember,
            currentShift: currentShift,
            positionList: positions));

  final CoreApiService? coreApiService = app<K2CoreApiClient>();

  void clockIn(K2Position position) {
    coreApiService!.clockInV2(
        personId: state.staffMember!.id,
        centerId: state.centerId,
        positionId: position.id!,
        type: 'SHIFT');
  }

  void clockOut(K2TimeEntry timeEntry) {
    coreApiService!.clockOut(timeEntry.id!);    
  }
}
