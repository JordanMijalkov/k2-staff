import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:k2_flutter_api/models/k2_time_off_request.dart';
import 'package:k2_flutter_api/models/enums/k2_time_off_request.dart';
import 'package:k2_staff/pages/time_off_request/cubit/time_off_request_cubit.dart';
import 'package:k2_staff/pages/time_off_request/time_off_request_tile.dart';

class TimeOffRequestHistoryScreen extends StatefulWidget {
  const TimeOffRequestHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TimeOffRequestHistoryScreen> createState() =>
      _TimeOffRequestHistoryScreenState();
}

class _TimeOffRequestHistoryScreenState
    extends State<TimeOffRequestHistoryScreen> {
  Future<List<K2TimeOffRequest>> _getHistoricalTimeOffRequests() async {
    var list = await context.read<TimeOffRequestCubit>().getMyHistoricalTimeOffRequests();
  
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    double width = min(460, _size.width * .90);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
                        FutureBuilder(
                  future: _getHistoricalTimeOffRequests(),
                  builder: (context, snapshot) {
                    int approvedRequests = 0;
                    int pendingRequests = 0;
                    int declinedRequests = 0;
                    if (snapshot.hasData) {
                      var requests =snapshot.data as List<K2TimeOffRequest>;
                      requests.forEach((request) {
                        switch (request.status) {
                          case K2TimeOffRequestStatus.APPROVED:
                            approvedRequests++;
                            break;
                          case K2TimeOffRequestStatus.PENDING:
                            pendingRequests++;
                            break;
                          case K2TimeOffRequestStatus.DENIED:
                            declinedRequests++;
                            break;
                          default:
                            break;
                        }
                      },);
                    }
                    return 
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Time Off History', style: Theme.of(context).textTheme.headline3),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  // child: Row(
                  //   children: [
                  //     Text('Approved ($approvedRequests)'),
                  //     SizedBox(width: 8,),
                  //     Text('Pending ($pendingRequests)'),
                  //     SizedBox(width: 8,),
                  //     Text('Declined ($declinedRequests)')
                  //   ],
                  // ),
                ),
                SizedBox(height: 18,),
                snapshot.hasData
                  ? Expanded(
                    child: (snapshot.data as List<K2TimeOffRequest>).isNotEmpty
                    ? ListView.builder(
                                itemCount:
                                    (snapshot.data as List<K2TimeOffRequest>)
                                        .length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  List<K2TimeOffRequest> requests =
                                      (snapshot.data as List<K2TimeOffRequest>);
                                      
                                      requests.sort((a, b) {
                                        if (DateTime.parse(a.startTime!).isBefore(DateTime.parse(b.startTime!)))
                                          return -1;
                                        if (a.startTime == b.startTime)
                                          return 0;
                                        else
                                          return 1;
                                      });
                                  return TimeOffRequestTile(request: requests[index], width: width);                                    
                                })
                    : Padding(
                      padding: const EdgeInsets.only(top:20.0, left: 8.0),
                      child: Text('No Current Time Off Requests', style: Theme.of(context).textTheme.headline6,),
                    )
                  )
                  : Text('Loading Requests....')
              ],
         
            ),
          );
   
                  }),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(thickness: 1, color: Colors.grey,),
              ),
              Row(
                children: [
                                    SizedBox(
                      height: 40,
//                      width: width,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<TimeOffRequestCubit>().resetState();
                        },
                        child: Text(
                          'Current Requests', style: TextStyle(fontSize: 12),
                        ),
                      )),
                  SizedBox(width: 12,),
                  SizedBox(
                      height: 40,
//                      width: width,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<TimeOffRequestCubit>().createTimeOff();
                        },
                        child: Text(
                          'Request Time Off', style: TextStyle(fontSize: 12),
                        ),
                      )),
                ],
              ),
                  SizedBox(height: 12,)
            ],
          )
        ],
      ),
    );
  }
}
