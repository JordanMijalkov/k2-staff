import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:k2_flutter_api/api/core_api_service.dart';
import 'package:k2_flutter_api/api/k2_core_api_client.dart';
import 'package:k2_flutter_api/api/responses/GetTimeEntriesForPersonAtCenterResponse.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:graphql/client.dart';
import '../../../core/services/service_locator.dart';

part 'time_off_request_state.dart';

class TimeOffRequestCubit extends Cubit<TimeOffRequestState> {
  TimeOffRequestCubit() : super(TimeOffRequestState());

  final CoreApiService coreApiService = app<K2CoreApiClient>();

  Future<List<K2TimeOffRequest>> getMyTimeOffRequests(
      String startTime, String endTime) async {
    final _data = (await coreApiService.getMyTimeOffRequests(startTime, endTime,
            fetchPolicy: FetchPolicy.cacheAndNetwork))!
        .data!;
    List<dynamic> timeOffs = _data['getMyTimeOffRequests'];
    List<K2TimeOffRequest> result = [];
    for (var timeOff in timeOffs) {
      result.add(K2TimeOffRequest.fromJson(timeOff));
    }
    return result;
  }

  Future<List<K2TimeOffRequest>> getMyHistoricalTimeOffRequests() async {
    final DateTime now = DateTime.now();
    String startTime = DateTime(now.year, now.month, now.day).add(Duration(days: -365)).toIso8601String();
    String endTime = DateTime(now.year, now.month, now.day, 23, 59,59).add(Duration(days: -1)).toIso8601String();
    final _data = (await coreApiService.getMyTimeOffRequests(startTime, endTime,
            fetchPolicy: FetchPolicy.cacheAndNetwork))!
        .data!;
    List<dynamic> timeOffs = _data['getMyTimeOffRequests'];
    List<K2TimeOffRequest> result = [];
    for (var timeOff in timeOffs) {
      result.add(K2TimeOffRequest.fromJson(timeOff));
    }
    return result;
  }  

  createTimeOffRequest(K2StaffProfile me, String type, DateTime? selectedDate,
      DateTimeRange? range, String description) async {
    // if (null == me.primaryCenter) {
    //       if (null != (me.roleship?.scopes ?? null))
    //   for (var scope in me.roleship!.scopes!) {
    //     if (scope is K2Entity) {
    //       entityId = scope.id;
    //         break;
    //       }

    //     }
    //   }

    double hours = 0;

    DateTime startDate;
    DateTime endDate;


    if (type == 'All Day') {
      startDate = selectedDate!;
      endDate = selectedDate;
      hours = 8.0;
    } else {
      startDate = range!.start;
      endDate = range.end;

      DateTime current = startDate;
      while(current.isBefore(endDate.add(Duration(days:1)))) {
        if (current.weekday < 6)
          hours += 8;

        current = current.add(Duration(days: 1));
      }
    }

    if (type == 'Partial Day') {
      Duration dur = endDate.difference(startDate);
      hours = dur.inMinutes / 60;
    }



    var response = await coreApiService.createMyTimeOffRequest(
        me.id,
        type == 'Partial Day' ? false : true,
        startDate.toUtc().toIso8601String(),
        endDate.toUtc().toIso8601String(),
        entityId: me.entityId,
        centerId: me.primaryCenter?.id,
        description: description,
        hoursApproved: hours);

    emit(state.copyWith(status: TimeOffRequestStatus.submitted));
  }

  void resetState() {
    emit(state.copyWith(status: TimeOffRequestStatus.review));
  }

  void createTimeOff() {
    emit(state.copyWith(status: TimeOffRequestStatus.creating));
  }

  void timeOffHistory() {
    emit(state.copyWith(status: TimeOffRequestStatus.history));
  }  

  Future<void> getExistingTimeOffRequests(K2StaffProfile me, DateTime startDate, DateTime endDate ) async {

    startDate = startDate.add(Duration(days: -startDate.weekday));
    endDate = endDate.add(Duration(days: 7-endDate.weekday, hours: 23, minutes: 59, seconds: 59));

    String scopeType = 'CENTER';
    String scopeId = '';

    if (null == me.primaryCenter!.id) {
      scopeType = 'ENTITY';
      scopeId = me.entityId!;
    }
    else
      scopeId = me.primaryCenter!.id!;

    GetTimeOffRequestsByScopeResponse response = await coreApiService.getTimeOffRequestsByScope(
      scopeType,
      scopeId,
      startDate.toIso8601String(),
      endDate.toIso8601String()
    );

    
    emit(state.copyWith(existingTimeOffRequests: response.timeOffRequests));
  }
}

