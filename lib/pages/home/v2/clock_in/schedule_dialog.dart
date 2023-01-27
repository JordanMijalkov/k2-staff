import 'dart:math';

import 'package:flutter/material.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:intl/intl.dart';
import 'package:k2_flutter_core/widgets/column_builder.dart';
import 'package:k2_staff/core/colors.dart';

class ScheduleDialog extends StatelessWidget {
  ScheduleDialog({ required this.schedule, required this.width, Key? key }) : super(key: key);
  final List<K2Shift> schedule;
  final DateFormat timeFormatter = new DateFormat('hh:mm:ss a');
  final double width;

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;
//    double _width = _size.width * .6;
    double _height = _size.height * .5;
    // double width = min(500, _size.width*.90);
  //  if (MediaQuery.of(context).orientation == Orientation.portrait){
//      _width = _size.width * .9;
//      _height = _size.height * .7;
 //   }

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Container(
          //width: width,
          height: _height,
          child: Padding(padding: const EdgeInsets.all(4),
            child: SingleChildScrollView(child: 
            ColumnBuilder(
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: IntrinsicHeight(
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            VerticalDivider(color: K2Colors.charcoalGrey,),
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Icon(Icons.schedule, color: K2Colors.charcoalGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: Text('${timeFormatter.format(DateTime.parse(schedule[index].startTime!).toLocal())} - ${timeFormatter.format(DateTime.parse(schedule[index].endTime!).toLocal())}',
                                    style: TextStyle(color: K2Colors.charcoalGrey)),
                                  )
                                ],),
                                SizedBox(height:6),
                                Row(children: [
                                  Icon(Icons.badge_outlined, color: K2Colors.charcoalGrey),
                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: Text(schedule[index].position?.title ?? 'No Position', style: TextStyle(color: K2Colors.charcoalGrey)),
                                  )
                                ],)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(height: 40,
          width: width,
            child: ElevatedButton(child: Text("Back"), 
                onPressed: () => Navigator.pop(context),),
          ),
        )
      ],),
      
    );
  }
}