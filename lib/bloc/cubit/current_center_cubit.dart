// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
// import 'package:k2_flutter_api/k2_flutter_util_responses.dart';
// import 'package:k2_flutter_api/repository/core_repository.dart';

// part 'current_center_state.dart';

// class CurrentCenterCubit extends Cubit<CurrentCenterState> {
//   CurrentCenterCubit() : super(CurrentCenterState());

//   Future<void> initializeCenters() async {
//     emit(state.copyWith(status: CurrentCenterStatus.initializing));

//       GetAllowedEntitiesResponse _response = await CoreRepository.instance.coreApiService.getAllowedEntities();
//       _response.entities[0].centers!.sort((a,b) => a.name!.compareTo(b.name!));
//       List<K2Entity> _allowedEntities = _response.entities;

//       if (_response.entities.length == 0 || (_response.entities[0].centers!.length == 0)) {
//         emit(state.copyWith(status: CurrentCenterStatus.noCenters));
//         return;
//       }

//       // if (null != event.me!.primaryCenter && _response.entities.indexWhere((element) => element.id == event.me!.primaryCenter!.id) == 0) {
//       //   emit(state.copyWith(status: CurrentCenterStatus.noCenters));
//       //   return; 
//       // }

//       // if (null != event.me!.primaryCenter!.id) {
//       //   K2StaffProfile me = event.me!;
//       //   if (null != me.primaryCenter)
//       //   yield CurrentCenter(allowedCenters: _response.entities[0].centers, center: me.primaryCenter!);
//       //   return;
//       // }

//       // yield CurrentCenter(allowedCenters: _response.entities[0].centers, center: _response.entities[0].centers![0]);

//   }

// }
