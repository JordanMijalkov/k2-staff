// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
// import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
// import 'package:k2_staff/bloc/deep_link/deep_link_cubit.dart';
// import 'package:k2_staff/pages/home/time_clock/clock_in/bloc/clock_in_bloc.dart';
// import 'package:k2_staff/pages/home/time_clock/clock_in/screens/select_position_screen.dart';
// import 'package:k2_staff/pages/home/time_clock/clock_in/screens/select_shift_screen.dart';

// class ClockInHost extends StatelessWidget {
//   ClockInHost({required this.centerId, required this.shiftOption});
//   final K2Shift? shiftOption; //= null == QR.params['shift'] ? null : QR.params['shift']!.valueAs<K2Shift>();
//   final String centerId;

//   @override
//   Widget build(BuildContext context) {
//         return BlocProvider(
//       create: (_) => ClockInBloc(
//         centerId: centerId,
//         employee: context.read<AuthenticationCubit>().state.staffProfile!),
      
//     child:BlocBuilder<ClockInBloc, ClockInState>(
//        builder: (context, state) {
    
//         if (state.isClockInInitial)
//           return SelectShiftScreen(shiftOption: shiftOption);
//         else if (state.isClockInSelectPosition)
//           return SelectPositionScreen(positionMap: (state as ClockInSelectPosition).positions,);

//         else return Placeholder();
//       }
      
//     ));
//   }
// }