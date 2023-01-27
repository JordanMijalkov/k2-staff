part of 'staff_cubit.dart';

class StaffState extends Equatable {
  late final List<K2Position> positions;
  final String centerId;
//  final String description;
  final K2StaffProfile? staffMember;
  final K2Shift? currentShift;

  StaffState({
    List<K2Position>? positionList, 
    this.centerId='', 
    this.staffMember, 
    this.currentShift,}) : this.positions = positionList ?? [];

  StaffState copyWith({
    List<K2Position>? positions,
    String? centerId,
    K2StaffProfile? staffMember,
    K2Shift? currentShift,
    }) {
    return StaffState(
      positionList: positions ?? this.positions,
      staffMember: staffMember ?? this.staffMember,
      currentShift: currentShift ?? this.currentShift,
      centerId: centerId ?? this.centerId
      );
  }

  @override
  List<Object?> get props => [positions, staffMember, currentShift, centerId];
}
