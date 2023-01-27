part of 'time_off_request_cubit.dart';

enum TimeOffRequestStatus { review, creating, submitted, history }

class TimeOffRequestState extends Equatable {
  const TimeOffRequestState({this.status = TimeOffRequestStatus.review, this.existingTimeOffRequests = const [] });

  final TimeOffRequestStatus status;
  final List<K2TimeOffRequest> existingTimeOffRequests;

  TimeOffRequestState copyWith({
    TimeOffRequestStatus? status,
    List<K2TimeOffRequest>? existingTimeOffRequests
  }) {
    return TimeOffRequestState(
      status: status ?? this.status,
      existingTimeOffRequests: existingTimeOffRequests ?? this.existingTimeOffRequests 
      );
  }

  @override
  List<Object> get props => [status, existingTimeOffRequests];
}

class TimeOffRequestInitial extends TimeOffRequestState {}
