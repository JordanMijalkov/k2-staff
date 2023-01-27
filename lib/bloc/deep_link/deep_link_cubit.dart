import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';

part 'deep_link_state.dart';

class DeepLinkCubit extends Cubit<DeepLinkState> {
  DeepLinkCubit() : super(const DeepLinkState());

  void readQRcode(int timeStamp, String centerId, AuthenticationState authState) {

    emit(state.copyWith(
      status: DeepLinkStatus.codeScanned, 
      centerId: centerId, 
      timeStamp: timeStamp,
      isAuthenticated: authState is AuthenticationState));
  }
}
