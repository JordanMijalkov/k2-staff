// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
// import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
// import 'package:k2_staff/bloc/deep_link/deep_link_cubit.dart';
// import 'package:k2_staff/pages/home/time_clock/clock_out/bloc/clock_out_bloc.dart';
// import 'package:k2_staff/pages/home/time_clock/k2_log_summary_item.dart';
// import 'package:k2_staff/pages/home/time_clock/time_log_summary.dart';
// import 'package:qlevar_router/qlevar_router.dart';

// class ClockOutScreen extends StatefulWidget {
//   ClockOutScreen({this.openTimeEntry, this.shift, this.logEntries, this.selectedShift});

// //  final K2Person? employee; // = QR.params['employee']!.valueAs<K2Person>();
//   final K2TimeEntry? openTimeEntry; // = QR.params['openTimeEntry']!.valueAs<K2TimeEntry>();
//   final K2Shift? shift; // = QR.params['shift']!.valueAs<K2Shift>();
//   final List<K2LogSummaryItem>? logEntries; // = QR.params['logEntries']!.valueAs<List<K2LogSummaryItem>>();
//   final K2Shift? selectedShift; // = QR.params['selectedShift']!.valueAs<K2Shift>();

//   @override
//   _ClockOutScreenState createState() => _ClockOutScreenState();
// }

// class _ClockOutScreenState extends State<ClockOutScreen> {

//   bool _isBreakSelected = false;

//   // ignore: close_sinks
//   late ClockOutBloc _bloc;
//   late K2StaffProfile employee;

//   @override
//   void initState() {
//     this.employee = context.read<AuthenticationCubit>().state.staffProfile!;
//     _bloc = ClockOutBloc(
//       employee: this.employee,
//       centerId: context.read<DeepLinkCubit>().state.centerId,);
//     _isBreakSelected = false;
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(ClockOutScreen oldWidget) {
//     _isBreakSelected = false;
//     super.didUpdateWidget(oldWidget);
//   }

//   _doTheThing(K2ClockOutType startBreak) async {
    
//     // We can re-use KioskNavEventClockInForScheduledShiftRequested
//     switch (widget.openTimeEntry!.type) {
//       case 'BREAK':
//         {
//           String _type = (widget.shift == null) ? 'UNSCHEDULED' : 'SHIFT';
//           _bloc.add(ClockOutResumeOrBreak(
//               timeEntry: widget.openTimeEntry,
//               employeeId: this.employee.id,
//               centerId: widget.openTimeEntry!.centerId,
//               positionId: widget.openTimeEntry!.positionId,
//               shiftId: widget.openTimeEntry!.shiftId,
//               scheduleId: widget.openTimeEntry!.scheduleId,
//               startBreak: startBreak,
//               shift: widget.shift,
//               type: _type));
//           break;
//         }
//       default:
//         {
//           if (_isBreakSelected) {
//             // Clock INTO break
//             _bloc.add(ClockOutResumeOrBreak(
//                 timeEntry: widget.openTimeEntry,
//                 employeeId: this.employee.id,
//                 centerId: widget.openTimeEntry!.centerId,
//                 positionId: widget.openTimeEntry!.positionId,
//                 shiftId: widget.openTimeEntry!.shiftId,
//                 scheduleId: widget.openTimeEntry!.scheduleId,
//                 startBreak: startBreak,
//                 type: 'BREAK'));
//           } else {
//             // Clock Out
//             _bloc.add(ClockOutRequestedEvent(
//               timeEntry: widget.openTimeEntry,
//               shift: widget.shift,
//               centerId: widget.openTimeEntry!.centerId,
//             ));
//           }
//           break;
//         }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = 400;

//     bool _showBreakButton = widget.openTimeEntry!.type != 'BREAK';  

//    // Display this if out open time entry type is SHIFT/UNSCHEDULED
//     // (we're going into a break, OR clocking out entirely)
//     Widget _breakButton = Padding(
//       padding: const EdgeInsets.only(top: 24.0),
//       child: ElevatedButton(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.local_cafe,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     widget.shift != null
//                         ? widget.shift!.breakMinutes! > 0
//                             ? Text(
//                                 "${widget.shift!.breakMinutes} minute break (${widget.shift!.paidBreak! ? "Paid" : "Unpaid"})")
//                             : Text("Take an unscheduled break")
//                         : Text("Clock out for a Break"),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         onPressed: () {
//           setState(() {
//             _isBreakSelected = !_isBreakSelected;
//             _doTheThing(K2ClockOutType.StartBreak);
//           });
//         },
//       ),
//     );

//     // Display this if our open time entry type is BREAK
//     // (we're going back into a shift)
//     Widget _shiftButton = Padding(
//       padding: const EdgeInsets.only(top: 24.0),
//       child: ElevatedButton(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.local_cafe,
//               ),
//               Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Text("Clock back in From Break")),
//             ],
//           ),
//         ),
//         onPressed: () {
//           _doTheThing(K2ClockOutType.EndBreak);
//         },
//       ),
//     );

//     return Scaffold(
//         body: BlocProvider(
//       create: (_) => _bloc,
      
//     child:BlocBuilder<ClockOutBloc, ClockOutState>(
//        builder: (context, state) {

//     return
    
//     Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//               width: 455,
// //            height: 390,
//               decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.surface,
//                   border: Border.all(
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(20))),
//               child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 60.0),
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                             padding: EdgeInsets.only(top: 34),
//                             child: Text(
//                               "Welcome back, ${this.employee.firstName}!",
//                               style: Theme.of(context).textTheme.headline2,
//                             )),
//                         _showBreakButton ? _breakButton : _shiftButton,
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 24.0),
//                           child: SizedBox(
// //                            height: 40.0,
//                               width: width,
//                               child: ElevatedButton(
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 12.0),
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.query_builder),
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 8.0),
//                                         child: Text("Clock out (End Shift)"),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   _doTheThing(K2ClockOutType.ClockOut);
//                                 },
//                               )),
//                         ),
//                         // Text("You're [XX] minutes [late/early]")
//                         if (this.widget.logEntries != null)
//                           TimeLogSummary(
//                             logEntries: this.widget.logEntries,
//                             shift: this.widget.selectedShift,
//                           )
//                       ]))),
//           Padding(
//             padding: const EdgeInsets.only(top: 45.0),
//             child: SizedBox(
//                 height: 40.0,
//                 width: 145,
//                 child: TextButton(
//                   child: Text("Cancel"),
//                   onPressed: () => QR.navigator.replaceAll('/home'),
//                 )),
//           ),
//         ],
//       ),
//     );
//        })));
//   }

// }