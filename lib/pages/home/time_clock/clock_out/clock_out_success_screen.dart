// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
// import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
// import 'package:k2_staff/pages/home/time_clock/k2_log_summary_item.dart';
// import 'package:k2_staff/pages/home/time_clock/time_log_summary.dart';
// import 'package:qlevar_router/qlevar_router.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';


// class ClockOutSuccessScreen extends StatelessWidget {
//   final K2TimeEntry? timeEntry = QR.params['timeEntry']!.valueAs<K2TimeEntry>();
//   //final K2Shift shift = QR.params['employee'].valueAs<K2Person>();
//   final K2ClockOutType? startBreak = QR.params['startBreak']!.valueAs<K2ClockOutType>();
//   final List<K2LogSummaryItem>? logEntries = QR.params['logEntries']!.valueAs<List<K2LogSummaryItem>>();
//   final K2Shift? selectedShift = null == QR.params['shift'] ? null : QR.params['shift']!.valueAs<K2Shift>();

//   final DateFormat timeFormatter = new DateFormat('hh:mm:ss a');

//   // ClockOutSuccessScreen(
//   //     {Key key,
//   //     @required this.employee,
//   //     @required this.timeEntry,
//   //     this.shift,
//   //     this.startBreak,
//   //     this.logEntries,
//   //     this.selectedShift})
//   //     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     K2StaffProfile employee = context.read<AuthenticationCubit>().state.staffProfile!;
//     double width = 353;

//     return Scaffold(

//           body: Center(
//             child: Wrap(children: [
//         Container(
//               width: 450,
//               padding: const EdgeInsets.symmetric(vertical: 60.0),
//               decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.surface,
//                   border: Border.all(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(20))),
//               child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 Icon(
//                   Icons.query_builder,
//                   color: Colors.greenAccent,
//                   size: 64,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text("Success!",
//                       style: Theme.of(context).textTheme.headline1),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 27.0),
//                   child: Text(
//                       startBreak == K2ClockOutType.StartBreak ||
//                               startBreak == K2ClockOutType.EndBreak
//                           ? startBreak == K2ClockOutType.StartBreak
//                               ? "Hope you have a great break, ${employee.firstName}!"
//                               : "Hope you had a great break, ${employee.firstName}!"
//                           : "Enjoy the rest of your day, ${employee.firstName}!",
//                       style: Theme.of(context).textTheme.bodyText2),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 27.0),
//                   child: Text(
//                       startBreak == K2ClockOutType.StartBreak ||
//                               startBreak == K2ClockOutType.EndBreak
//                           ? startBreak == K2ClockOutType.StartBreak
//                               ? "Clocked out at ${timeFormatter.format(new DateTime.now().toLocal())}"
//                               : "Clocked back in at ${timeFormatter.format(new DateTime.now().toLocal())}"
//                           : "Clocked out at ${timeFormatter.format(new DateTime.now().toLocal())}",
//                       style: Theme.of(context).textTheme.headline2),
//                 ),
//                 if (this.logEntries != null)
//                   Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 60.0),
//                       child: TimeLogSummary(
//                         logEntries: this.logEntries,
//                         shift: this.selectedShift,
//                       )),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 24.0),
//                   child: SizedBox(
//                       height: 40.0,
//                       width: width,
//                       child: ElevatedButton(
//                         child: Text("Close"),
//                         onPressed: () {
//                           QR.navigator.replaceAll('/home');
//                         },
//                       )),
//                 ),
//               ]))
//       ]),
//           ),
//     );
//   }
// }
