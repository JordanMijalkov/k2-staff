part of 'authentication_cubit.dart';

enum AuthenticationStatus { unauthenticated, awaiting, authenticated }

class AuthenticationState extends Equatable {
  AuthenticationState({
    this.status  = AuthenticationStatus.unauthenticated,
    this.user,
    this.entityId,
    this.staffProfile,
    List<K2Center>? centerList }) : centers = centerList ?? [];

  final AuthenticationStatus status;
  final K2User? user;
  K2StaffProfile? staffProfile;
  final String? entityId;
  late final List<K2Center> centers;

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    K2User? user,
    String? entityId,
    K2StaffProfile? staffProfile,
    List<K2Center>? centers
  }) {
    print('updating App State....');
    
    return AuthenticationState(
      status: status ?? this.status,
      user: user ?? this.user,
      entityId: entityId ?? this.entityId,
      staffProfile: staffProfile ?? this.staffProfile,
      centerList: centers ?? this.centers,
      );
  }

  @override
  List<Object?> get props => [status, user, entityId, centers, staffProfile];
}


