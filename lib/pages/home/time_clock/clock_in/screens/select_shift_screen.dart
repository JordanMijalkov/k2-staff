// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
// import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
// import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
// import 'package:k2_staff/pages/home/time_clock/clock_in/bloc/clock_in_bloc.dart';
// import 'package:k2_staff/pages/home/time_clock/clock_in/button_styles.dart';
// import 'package:qlevar_router/qlevar_router.dart';

// class SelectShiftScreen extends StatefulWidget {
//   SelectShiftScreen({required this.shiftOption});
  
//   final K2Shift? shiftOption; // = QR.params['shift'].valueAs<K2Shift>();

//   @override
//   _SelectShiftScreenState createState() => _SelectShiftScreenState();
// }

// class _SelectShiftScreenState extends State<SelectShiftScreen> {
//   DateFormat timeFormatter = new DateFormat('hh:mm a');

//   String? _selectedShiftId;

//   @override
//   void initState() {
//     if (widget.shiftOption != null) {
//       _selectedShiftId = widget.shiftOption!.id;
//     } else {
//       _selectedShiftId = null;
//     }
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(SelectShiftScreen oldWidget) {
//     if (widget.shiftOption != null) {
//       _selectedShiftId = widget.shiftOption!.id;
//     } else {
//       _selectedShiftId = null;
//     }
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//   K2StaffProfile me = context.read<AuthenticationCubit>().state.staffProfile!;
//   // final K2Person employee = QR.params['employee'].valueAs<K2Person>();
//   // final K2Shift widget.shiftOption = QR.params['widget.shiftOptions'].valueAs<K2Shift>();

//     //  K2Person employee = context.read<ApplicationCubit>().state.staff;
//     //  K2Shift widget.shiftOption = context.read<ApplicationCubit>().state.shift;
    
//     double width = 353;

//     // Negative means LATE in this configuration
//     String _lateMessage = '';
//     if (widget.shiftOption != null) {
//       int _minutes = DateTime.parse(widget.shiftOption!.startTime!)
//           .difference(DateTime.now())
//           .inMinutes;
//       if (_minutes > 0) {
//         _lateMessage = "You're $_minutes minutes early.";
//       } else if (_minutes < 0) {
//         _lateMessage = "You're ${_minutes.abs()} minutes late.";
//       } else {
//         // Special message for today's lucky winner!
//         _lateMessage = "You're right on time!";
//       }
//     }

//     List<Widget> _selectableShifts = [];
//     if (widget.shiftOption != null) {
//       final _isSelected = (_selectedShiftId != null);
//       Widget option = Padding(
//         padding: const EdgeInsets.only(top: 24.0),
//         child: OutlinedButton (
//           style: _isSelected ? selectedoutlineButtonStyle : outlineButtonStyle,
//             // borderSide: _isSelected
//             //     ? BorderSide(color: Colors.greenAccent, width: 2.0)
//             //     : BorderSide(
//             //         color: Theme.of(context).colorScheme.onSurface, width: 2.0),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Row(
//                 children: [
//                   _isSelected
//                       ? Icon(Icons.check_circle, color: Colors.green)
//                       : Padding(
//                           padding: EdgeInsets.only(left: 24.0),
//                         ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "${timeFormatter.format(DateTime.parse(widget.shiftOption!.startTime!).toLocal())} - ${timeFormatter.format(DateTime.parse(widget.shiftOption!.endTime!).toLocal())}",
//                           style: Theme.of(context).textTheme.bodyText2,
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                                 "${widget.shiftOption!.k2class!.name ?? widget.shiftOption!.location!.name ?? ''}",
//                                 style: Theme.of(context).textTheme.bodyText2),
//                             Text(
//                               " (${widget.shiftOption!.position!.title})",
//                               style: Theme.of(context).textTheme.bodyText2,
//                             ),
//                           ],
//                         ),
//                         Text(
//                           _lateMessage,
//                           style: Theme.of(context).textTheme.caption,
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             onPressed: () {
//               setState(() {
//                 _selectedShiftId = widget.shiftOption!.id;
//               });
//             },
//             // shape: RoundedRectangleBorder(
//             //     borderRadius: new BorderRadius.circular(5.0))
//                 ),
//       );
//       _selectableShifts.add(option);
//     }

//     // Unscheduled button
//     Widget _unscheduled = Padding(
//       padding: const EdgeInsets.only(top: 16.0),
//       child: OutlinedButton(
//         style: _selectedShiftId == null ? selectedoutlineButtonStyle : outlineButtonStyle,
//           // borderSide: _selectedShiftId == null
//           //     ? BorderSide(color: Colors.greenAccent, width: 2.0)
//           //     : BorderSide(
//           //         color: Theme.of(context).colorScheme.onSurface, width: 2.0),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12.0),
//             child: Row(
//               children: [
//                 _selectedShiftId == null
//                     ? Icon(Icons.check_circle, color: Colors.green)
//                     : Padding(
//                         padding: EdgeInsets.only(left: 24.0),
//                       ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           _selectedShiftId != null
//                               ? Text("Select ",
//                                   style: Theme.of(context).textTheme.bodyText2)
//                               : Container(),
//                           Text("Unscheduled Shift",
//                               style: Theme.of(context).textTheme.bodyText2),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           onPressed: () {
//             setState(() {
//               _selectedShiftId = null;
//             });
//           },
//           // shape: RoundedRectangleBorder(
//           //     borderRadius: new BorderRadius.circular(5.0))
//               ),
//     );
//     _selectableShifts.add(_unscheduled);

//     String greeting;
//     TimeOfDay.now().period == DayPeriod.am
//         ? greeting = "Good Morning"
//         : greeting = "Good Afternoon";

//     return BlocBuilder<ClockInBloc, ClockInState>(
//        builder: (context, state) {
//     return Scaffold(
//         // showIcon: true,
//         // title: "",
//         body:
//     Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//               width: 425,
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
//                               "$greeting, ${me.firstName}",
//                               style: Theme.of(context).textTheme.headline2,
//                             )),
//                         ..._selectableShifts,
//                         _selectableShifts.length == 1
//                             ? Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Container(
//                                     child: Row(
//                                   children: <Widget>[
//                                     Flexible(
//                                         child: new Text(
//                                             "You do not have a currently scheduled shift.  Please ensure this is approved by your supervisor before you Clock-In"))
//                                   ],
//                                 )),
//                               )
//                             : Container(),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 24.0),
//                           child: SizedBox(
//                               height: 40.0,
//                               width: width,
//                               child: ElevatedButton(
//                                 child: Text("Clock In"),
//                                 onPressed: () {
//                                   _selectedShiftId == null
//                                   ? 
//                                   context.read<ClockInBloc>()
//                                       .add(ClockInForUnscheduledShift())
//                                        // shift: widget.shiftOption))
//                                   : 
//                                   context.read<ClockInBloc>()
//                                       .add(ClockInForScheduledShift(
//                                         position: widget.shiftOption!.position,
//                                         type: 'SHIFT',
//                                        // shiftId: 
//                                         scheduleId: widget.shiftOption!.scheduleId,
//                                         selectedShift: widget.shiftOption
//                                       ));
//                                   // _selectedShiftId != null
//                                   //     ? BlocProvider.of<KioskNavBloc>(context).add(
//                                   //         KioskNavEventClockInForScheduledShiftRequested(
//                                   //             employee: employee,
//                                   //             centerId:
//                                   //                 widget.shiftOption.centerId,
//                                   //             position:
//                                   //                 widget.shiftOption.position,
//                                   //             shiftId: _selectedShiftId,
//                                   //             scheduleId:
//                                   //                 widget.shiftOption.scheduleId,
//                                   //             type: 'SHIFT',
//                                   //             selectedShift: widget.shiftOption))
//                                   //     : BlocProvider.of<KioskNavBloc>(context).add(
//                                   //         KioskNavEventClockInForUnscheduledShiftRequested(
//                                   //             employee: employee));
//                                 },
//                               )),
//                         ),

//                       ]))),
//           Padding(
//             padding: const EdgeInsets.only(top: 45.0),
//             child: SizedBox(
//                 height: 40.0,
//                 width: 145,
//                 child: TextButton(
//                   child: Text("Cancel"),
//                   onPressed: () {
//                     QR.navigator.replaceAll('/home');
//                     //context.read<
//                     // BlocProvider.of<KioskNavBloc>(context)
//                     //     .add(KioskNavEventCenterSelected(selectedCenter: null));
//                   },
//                 )),
//           ),
//         ],
//       ),
//     ));
    
//        });
//   }
// }