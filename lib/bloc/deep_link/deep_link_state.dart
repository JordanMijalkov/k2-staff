part of 'deep_link_cubit.dart';

enum DeepLinkStatus { noLink, codeScanned }

class DeepLinkState extends Equatable {
  const DeepLinkState({ this.status = DeepLinkStatus.noLink, this.centerId, this.timeStamp, this.isAuthenticated });

  final DeepLinkStatus status;
  final String? centerId;
  final int? timeStamp;
  final bool? isAuthenticated;

  DeepLinkState copyWith({
    DeepLinkStatus? status, String? centerId, int? timeStamp, bool? isAuthenticated
  }) {
    return DeepLinkState(
      status: status ?? this.status,
      centerId: centerId ?? this.centerId,
      timeStamp: timeStamp ?? this.timeStamp,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated
    );
  }

  @override
  List<Object?> get props => [status, centerId, timeStamp, isAuthenticated];
}
