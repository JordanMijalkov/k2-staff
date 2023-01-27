import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_flutter_api/models/k2_time_off_request.dart';

class TimeOffRequestTile extends StatelessWidget {
  TimeOffRequestTile({ required this.request, required this.width, Key? key }) : super(key: key);
  final K2TimeOffRequest request;
  final double width;
  final DateFormat dateFormatter = new DateFormat('E MMM d');
  final DateFormat dateFormatter2 = new DateFormat('MM-dd-yy');
  final DateFormat dateFormatter3 = new DateFormat('hh:mm a');
  
  @override
  Widget build(BuildContext context) {
    String requestType = 'All Day';
    DateTime start = DateTime.parse(request.startTime!);
    DateTime end = DateTime.now();

    Color statusColor = _statusColor(request.status ?? K2TimeOffRequestStatus.PENDING);

    if (!(request.allDay ?? true)) {
      
      end = DateTime.parse(request.endTime!);
      
      if (start.day == end.day && start.month == end.month && start.year == end.year)
        requestType = 'Partial Day';
      else
        requestType = 'Multiple Days';
    }

    return 
    
    Padding(
      padding: const EdgeInsets.only(bottom:12.0),
      child: Material(
        elevation: 2,
        borderRadius: const BorderRadius.all(
                                      const Radius.circular(6.0)),
        child: Container(
                              decoration: BoxDecoration(
                                  
                                  gradient: LinearGradient(stops: [
                                    0.3,
                                    0.3
                                  ], colors: [
                                    Colors.blue[600]!,Colors.white
                                  ]),
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(6.0))),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Expanded(flex: 1,
            child: Row(
              children: [
                Padding(
                      padding: const EdgeInsets.only(left: 16, top: 20.0, bottom:20.0, right: 12),
                      child: Text(dateFormatter.format(start), style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                
              ],
            ),
          ),
          
          Expanded(flex: 2,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(requestType, style: TextStyle(color: Colors.grey[800], fontSize: 10),),
                  if (requestType == 'Multiple Days')
                    Text('${dateFormatter2.format(start)} to ${dateFormatter2.format(end)}', style: TextStyle(color: Colors.grey[800], fontSize: 10)),
                  if (requestType == 'Partial Day')
                    Text('${dateFormatter3.format(start)} to ${dateFormatter3.format(end)}', style: TextStyle(color: Colors.grey[800], fontSize: 10))

                ]),
                Padding(
                  padding: const EdgeInsets.only(right:16.0, top: 20, bottom: 20),
                  child: Row(children: [
                    Icon(Icons.check, color: statusColor, size: 18,),
                    Text(_status(request.status ?? K2TimeOffRequestStatus.PENDING), style: TextStyle(color: statusColor, fontSize: 10),)
                  ]
                  ),
                ),
              ],
            ),
          )
        ]),
        ),
      ),
    );
    
  }

    Color _statusColor(K2TimeOffRequestStatus status) {
    switch (status) {
      case K2TimeOffRequestStatus.APPROVED:
        return Colors.green;
      case K2TimeOffRequestStatus.CANCELED:
        return Colors.grey[800]!;
      case K2TimeOffRequestStatus.DENIED:
        return Colors.red;
      case K2TimeOffRequestStatus.PENDING:
        return Colors.amber[600]!;
    }
  }

  String _status(K2TimeOffRequestStatus status) {
    switch (status) {
      case K2TimeOffRequestStatus.APPROVED:
        return 'Approved';
      case K2TimeOffRequestStatus.CANCELED:
        return 'Cancelled';
      case K2TimeOffRequestStatus.DENIED:
        return 'Denied';
      case K2TimeOffRequestStatus.PENDING:
        return 'Pending';
    }
  }
}