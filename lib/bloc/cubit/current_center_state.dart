// part of 'current_center_cubit.dart';

// enum CurrentCenterStatus { initializing, changing, currentCenter, noCenters }

// class CurrentCenterState extends Equatable {
//   CurrentCenterState({
//     this.status = CurrentCenterStatus.initializing,
//     this.center,
//     List<K2Center>? centerList
//   }) : allowedCenters = centerList ?? [];

//   final K2Center? center;
//   final List<K2Center> allowedCenters;
//   final CurrentCenterStatus status; 

//   CurrentCenterState copyWith({
//     CurrentCenterStatus? status,
//     K2Center? center,
//     List<K2Center>? allowedCenters,
//   }) {
//     return CurrentCenterState(
//       status: status ?? this.status,
//       center: center ?? this.center,
//       centerList: allowedCenters ?? this.allowedCenters,
//     );
//   }

//   @override
//   List<Object?> get props => [status, center, allowedCenters];
// }
