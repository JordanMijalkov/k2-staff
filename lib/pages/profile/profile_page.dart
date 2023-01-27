import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_staff/pages/profile/bloc/profile_screen/profile_screen_cubit.dart';
import 'package:k2_staff/pages/profile/profile_phone_host_page.dart';
import 'package:k2_staff/pages/profile/profile_tablet_host_page.dart';
import 'package:k2_staff/pages/profile/screens/emergency_contact_form.dart';
import 'package:k2_staff/pages/profile/screens/profile_form.dart';
import 'package:k2_staff/pages/profile/screens/profile_menu_phone.dart';
import 'package:responsive_builder/responsive_builder.dart';


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileMenuPhone();
  }

//   Widget _tabletMenu(context) {
//     return Row(
//       children: <Widget>[
//         Expanded(
//             child: Container(
//                 color: Colors.grey,
//                 child: Center(
//                     child: Container(
//                         width: 830,
//                         padding: EdgeInsets.only(top: 24),
//                         color: Colors.grey,
//                         child: DefaultTabController(
//                             length: 2,
//                             child: Scaffold(
//                               backgroundColor: Colors.transparent,
//                               appBar: PreferredSize(
//                                   preferredSize: Size.fromHeight(48.0),
//                                   child: AppBar(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(6))),
//                                     elevation: 1.0,

// //      key: heightKey,
//                                     backgroundColor: Colors.white,
//                                     bottom: TabBar(
//                                       labelColor: Colors.black,
//                                       indicatorColor: Colors.pinkAccent,
//                                       tabs: [
//                                         Tab(icon: Text("Profile")),
//                                         Tab(icon: Text("Employment")),
//                                       ],
//                                     ),
//                                   )),
//                               body: TabBarView(
//                                 children: <Widget>[
//                                   Center(
//                                     child: _tabletProfile(context),
//                                   ),
//                                   Center(
//                                     child: Container(color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ))))))
//       ],
//     );

    // Row(children: <Widget>[

    //   Column(children: <Widget>[
    //     Text("Profile Information"),
    //     Text("Emergency Contact")
    //   ],),

    //   Column(children: <Widget>[
    //     Text("Change Password"),
    //     Text("Change PIN")
    //   ]),
    // ],)
  }

//   Widget _tabletProfile(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.only(top: 8),
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               flex: 3,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 24.0),
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                         color: Colors.white,
//                         child: ProfileForm(
//                           onSubmit: (profile) {
//                             print(profile.toString());
//                           },
//                           k2staffProfile: ,
//                         )),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Container(
//                           color: Colors.white, child: EmergencyContactForm()),
//                     ),
//                     //  Container(color: Colors.white, child:Text("Emergency Contact")),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Column(children: <Widget>[
//                 Container(color: Colors.white, child: _changePassword(context)),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16.0),
//                   child: Container(
//                       color: Colors.white, child: _changePIN(context)),
//                 )
//               ]),
//             )
//           ],
//         ));
//   }

//   Widget _changePassword(BuildContext context) {
//     return Container(
// //        padding: EdgeInsets.all(16),
//         color: Colors.grey,
//         child: Container(
//             color: Colors.transparent,
//             child: new Container(
//                 decoration: new BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         new BorderRadius.all(const Radius.circular(8.0))),
//                 child: Padding(
//                   padding: EdgeInsets.all(36),
//                   child: Column(
//                     children: <Widget>[
//                       ClipOval(
//                         child: Material(
//                           color: Colors.yellow, // button color
//                           child: SizedBox(
//                               width: 48,
//                               height: 48,
//                               child: Icon(Icons.vpn_key, color: Colors.black)),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 28.0, bottom: 4),
//                         child: Text("Need to change your"),
//                       ),
//                       Text("Password?"),
//                       Padding(
//                           padding: EdgeInsets.only(top: 16.0),
//                           child: SizedBox(
//                               height: 40.0,
//                               width: 190,
//                               child: FlatButton(
//                                 child: Text("Change Password"),
//                                 textColor: Colors.black38,
//                                 disabledColor: const Color(0xfff6f7fb),
//                                 splashColor: Color(0xffba0045),
//                                 color: Color(0xffffffff),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     side: BorderSide(color: Colors.black38)),
//                                 onPressed: () {
//                                   // BlocProvider.of<LoginBloc>(context)
//                                   //     .add(LoginEventSSOLoginRequest());
//                                 },
//                               ))),
//                     ],
//                   ),
//                 ))));
//   }

//   Widget _changePIN(BuildContext context) {
//     return Container(
// //        padding: EdgeInsets.all(16),
//         color: Colors.grey,
//         child: Container(
//             color: Colors.transparent,
//             child: new Container(
//                 decoration: new BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         new BorderRadius.all(const Radius.circular(8.0))),
//                 child: Padding(
//                   padding: EdgeInsets.all(36),
//                   child: Column(
//                     children: <Widget>[
//                       ClipOval(
//                         child: Material(
//                           color: Colors.grey, // button color
//                           child: SizedBox(
//                               width: 48,
//                               height: 48,
//                               child: Icon(Icons.lock_outline,
//                                   color: Colors.black)),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 28.0, bottom: 4),
//                         child: Text("Need to update your"),
//                       ),
//                       Text("PIN code?"),
//                       Padding(
//                           padding: EdgeInsets.only(top: 16.0),
//                           child: SizedBox(
//                               height: 40.0,
//                               width: 190,
//                               child: FlatButton(
//                                 child: Text("Change PIN"),
//                                 textColor: Colors.black38,
//                                 disabledColor: const Color(0xfff6f7fb),
//                                 splashColor: Color(0xffba0045),
//                                 color: Color(0xffffffff),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     side: BorderSide(color: Colors.black38)),
//                                 onPressed: () {
//                                   // BlocProvider.of<LoginBloc>(context)
//                                   //     .add(LoginEventSSOLoginRequest());
//                                 },
//                               ))),
//                     ],
//                   ),
//                 ))));
//   }
// }
