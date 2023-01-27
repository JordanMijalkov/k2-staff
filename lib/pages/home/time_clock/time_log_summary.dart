// import 'package:flutter/material.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
// import 'package:k2_staff/core/widgets/clock_icon.dart';
// import 'package:k2_staff/pages/home/time_clock/k2_log_summary_item.dart';




// class TimeLogSummary extends StatelessWidget {
//   final List<K2LogSummaryItem>? logEntries;
//   final K2Shift? shift;

//   TimeLogSummary({Key? key, this.logEntries, this.shift}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//    // const listTextStyle = TextStyle(fontSize: 12, color: K2Colors.blueyGrey);
//     return Container(
//         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//         child: (Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Here's the summary of your day."),
//             SizedBox(height: 10),
//             if (shift != null)
//               Container(
//                   decoration:
//                       new BoxDecoration(color: Theme.of(context).colorScheme.surface),
//                   child: ListTile(
//                     leading: Text("Shift:"),
//                     title: Wrap(
//                       direction: Axis.vertical,
//                       children: [
//                         Text(
//                             "${Jiffy(shift!.startTime).format("h:mm a")} - ${Jiffy(shift!.endTime).format("h:mm a")} (${Jiffy(shift!.endTime).diff(Jiffy(shift!.startTime), Units.HOUR)} hr(s))"),
//                         if (shift!.breakMinutes! > 0)
//                           Text(
//                             "(${shift!.breakMinutes}m Break)",
//                           //  style: listTextStyle,
//                           )
//                       ],
//                     ),
//                   )),
//             ListView.separated(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 separatorBuilder: (context, index) => Divider(
//                       thickness: 0.8,
//                   //    color: K2Colors.lightBlueGrey,
//                     ),
//                 itemCount: logEntries!.length,
//                 itemBuilder: (context, index) {
//                   K2LogSummaryItem log = logEntries![index];
//                   return ListTile(
//                       leading: ClockIcon(ccType: log.type),
//                       title: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(log.title!, maxLines: 2,), // style: listTextStyle),
//                           Text(Jiffy(log.time).format("h:mm a"))
//                         ],
//                       ),
//                       trailing: Text(
//                           "${(log.trailingText != null ? log.trailingText : shift?.position?.title) ?? ''}",
//                           //style: listTextStyle
//                           ));
//                 }),
//             Divider(
//               thickness: 0.8,
//            //   color: K2Colors.lightBlueGrey,
//             ),
//             if (logEntries!.last.type == K2ClockOutType.StartBreak &&
//                 shift != null &&
//                 shift!.breakMinutes! > 0)
//               ListTile(
//                 leading: ClockIcon(
//              //     iconColor: K2Colors.lightBlueGrey,
//                 ),
//                 title: Wrap(
//                   direction: Axis.vertical,
//                   children: [
//                     Text("Clock in", ), //style: listTextStyle),
//                     Text(
//                       "expected to clock in: ${(Jiffy(logEntries!.last.time)..add(duration: Duration(minutes: shift!.breakMinutes as int))).format("h:mm a")}",
//                       style:
//                           TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
//                       maxLines: 2,
//                     )
//                   ],
//                 ),
//               ),
//             if (logEntries!.last.type == K2ClockOutType.ClockOut)
//               ListTile(
//                 title: Center(
//                   child: Text(
//                       "Total: ${Jiffy(logEntries?.last.time).diff(Jiffy(logEntries?.first.time), Units.HOUR)} hour(s)"),
//                 ),
//               )
//           ],
//         )));
//   }
// }