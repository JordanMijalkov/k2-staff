// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:k2_staff/pages/profile/screens/profile_menu_phone.dart';
// import 'bloc/phone_screen/bloc.dart';


// class ProfilePhoneHostPage extends StatelessWidget {
  
//   @override
//   Widget build(BuildContext context) {
// //    return Placeholder();
//     return BlocProvider<PhoneScreenBloc>(
//         create: (BuildContext context) => PhoneScreenBloc(),
//         child: BlocBuilder<PhoneScreenBloc, PhoneScreenState>(
//           builder: (context, state) {
//             return state is CurrentPage
//                     ? state.page    
//                     : ProfileMenuPhone();
//          },
//        ));
//   }
// }