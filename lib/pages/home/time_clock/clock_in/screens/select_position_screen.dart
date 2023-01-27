// import 'package:flutter/material.dart';
// import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:k2_staff/pages/home/time_clock/clock_in/bloc/clock_in_bloc.dart';


// class SelectPositionScreen extends StatefulWidget {
//   SelectPositionScreen({required this.positionMap});

//   final Map<String?, K2Position> positionMap; // = QR.params['positionMap'].valueAs<Map<String, K2Position>>();
    
//   @override
//   _SelectPositionScreenState createState() => _SelectPositionScreenState();
  
// }

// class _SelectPositionScreenState extends State<SelectPositionScreen> {
//   String? _selectedPosition;
//   List<DropdownMenuItem<String>>? _positionDropdownOptions;

//   @override
//   void initState() {
//     _selectedPosition = widget.positionMap.keys.first;
//     _positionDropdownOptions =
//         widget.positionMap.entries.map<DropdownMenuItem<String>>((entry) {
//       return DropdownMenuItem<String>(
//         value: entry.key,
//         child: Text("${entry.value.title}"),
//       );
//     }).toList();
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(SelectPositionScreen oldWidget) {
//     _selectedPosition = widget.positionMap.keys.first;
//     _positionDropdownOptions =
//         widget.positionMap.entries.map<DropdownMenuItem<String>>((entry) {
//       return DropdownMenuItem<String>(
//         value: entry.key,
//         child: Text("${entry.value.title}"),
//       );
//     }).toList();
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = 353;

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//             width: 425,
//          //   height: 390,
//             decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.surface,
//                 border: Border.all(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//                 borderRadius: BorderRadius.all(Radius.circular(20))),
//             child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 60.0),
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                           padding: EdgeInsets.only(top: 34),
//                           child: Text(
//                             "Okay, which position?",
//                             style: Theme.of(context).textTheme.headline1,
//                           )),
//                       Padding(
//                           padding: EdgeInsets.only(top: 16),
//                           child: Text(
//                             "Select the position for your shift.",
//                             style: Theme.of(context).textTheme.bodyText1,
//                           )),
//                       Padding(
//                           padding: EdgeInsets.only(top: 24),
//                           child: Text(
//                             "Position:",
//                             style: Theme.of(context).textTheme.bodyText1,
//                           )),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 5.0),
//                         child: Container(
//                           width: width,
//                           padding: EdgeInsets.symmetric(horizontal: 10.0),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5.0),
//                             border: Border.all(
//                                 color: Theme.of(context).colorScheme.onSurface,
//                                 style: BorderStyle.solid,
//                                 width: 0.80),
//                           ),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButton<String>(
//                               value: _selectedPosition,
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   _selectedPosition = newValue;
//                                 });
//                               },
//                               items: _positionDropdownOptions,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 28.0),
//                         child: SizedBox(
//                             height: 40.0,
//                             width: width,
//                             child: ElevatedButton(
//                               child: Text("Clock In"),
//                               onPressed: () {
//                                 context.read<ClockInBloc>()
//                                     .add(ClockInForUnscheduledShift(
//                                       position: widget.positionMap[_selectedPosition]));

//                                 // BlocProvider.of<KioskNavBloc>(context).add(
//                                 //     KioskNavEventClockInForUnscheduledShiftRequested(
//                                 //         employee: widget.employee,
//                                 //         position: widget
//                                 //             .positionMap[_selectedPosition]));
//                               },
//                             )),
//                       ),
//                     ]))),
//         Padding(
//           padding: const EdgeInsets.only(top: 45.0),
//           child: SizedBox(
//               height: 40.0,
//               width: 145,
//               child: TextButton(
//                 child: Text("Cancel"),
//                 onPressed: () {
//                   // BlocProvider.of<KioskNavBloc>(context)
//                   //     .add(KioskNavEventCenterSelected(selectedCenter: null));
//                 },
//               )),
//         ),
//       ],
//     );
//   }
// }