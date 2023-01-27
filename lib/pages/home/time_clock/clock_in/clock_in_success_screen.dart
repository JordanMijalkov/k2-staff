// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
// import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
// import 'package:k2_staff/pages/home/time_clock/k2_log_summary_item.dart';
// import 'package:k2_staff/pages/home/time_clock/time_log_summary.dart';
// import 'package:qlevar_router/qlevar_router.dart';

// class ClockInSuccessScreen extends StatelessWidget {
//   final K2Position? position = QR.params['position']!.valueAs<K2Position>();
// //  final K2Shift shift = QR.params['shift'].valueAs<K2Shift>();
//   final List<K2LogSummaryItem>? logEntries = QR.params['logEntries']!.valueAs<List<K2LogSummaryItem>>();
//   final K2Shift? selectedShift = null == QR.params['shift'] ? null : QR.params['shift']!.valueAs<K2Shift>();

//   final DateFormat timeFormatter = new DateFormat('hh:mm:ss a');

//   @override
//   Widget build(BuildContext context) {
//     K2StaffProfile employee = context.read<AuthenticationCubit>().state.staffProfile!;
//     double width = 353;

//     return Scaffold(
//         body:Center(
//           child: Wrap(
//                     children: [Container(
//                 width: 450,
//                 padding: const EdgeInsets.symmetric(vertical: 60.0),
//                 decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.surface,
//                     border: Border.all(
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     borderRadius: BorderRadius.all(Radius.circular(20))),
//                 child: Column(mainAxisAlignment: MainAxisAlignment.center, 
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.query_builder,
//                     color: Colors.greenAccent,
//                     size: 64,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text("Success!",
//                         style: Theme.of(context).textTheme.headline1),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 27.0),
//                     child: Text("Have a great shift, ${employee.firstName}!",
//                         style: Theme.of(context).textTheme.bodyText2),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 27.0),
//                     child: Text(
//                         "Clocked in ${timeFormatter.format(new DateTime.now().toLocal())}",
//                         style: Theme.of(context).textTheme.headline2),
//                   ),
//                   if (this.logEntries != null)
//                     Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 60.0),
//                         child: TimeLogSummary(
//                           logEntries: this.logEntries,
//                           shift: this.selectedShift,
//                         )),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: SizedBox(
//                         height: 40.0,
//                         width: width,
//                         child: ElevatedButton(
//                           child: Text("Close"),
//                           onPressed: () {
//                             QR.navigator.replaceAll('/home');
//                           },
//                         )),
//                   ),
//                 ])),
//                     ]),
//         ));
//   }
// }