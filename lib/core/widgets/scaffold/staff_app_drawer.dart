import 'package:flutter/material.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_staff/bloc/application/application_cubit.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_staff/core/widgets/k2_staff_profile_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';


class StaffAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    

    K2StaffProfile _k2staffProfile =
        context.read<AuthenticationCubit>().state.staffProfile!;

                  
      return Drawer(
          elevation: 1.5,
          child: Column(children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text(_k2staffProfile.email!),
              accountName: Text(_k2staffProfile.fullName),
              currentAccountPicture: _k2staffProfile.avatarWidget(),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(110),
              //   child: Image.asset(
              //     _k2staffProfile.avatar.url,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              // otherAccountsPictures: <Widget>[
              //   ClipRRect(
              //     borderRadius: BorderRadius.circular(110),
              //     child: Image.asset(
              //       "assets/images/chameleon3.jpg",
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              //   ClipRRect(
              //     borderRadius: BorderRadius.circular(110),
              //     child: Image.asset(
              //       "assets/images/chameleon3.jpg",
              //       fit: BoxFit.cover,
              //     ),
              //   )
              // ],
              decoration: BoxDecoration(color: Colors.blue),
            ),
            Expanded(
                child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                // ListTile(
                //   leading: Icon(Icons.school),
                //   title: Text("Home"),
                //   onTap: () {
                //     QR.to('/home');
                //     // BlocProvider.of<HomeNavBloc>(context)
                //     //     .add(Navigate(page: HomeDashboardPage()));
                //     // Navigator.pop(context);
                //   },
                // ),
          // ListTile(
          //     title: Text("QR Scanner"),
          //     leading: Icon(Icons.qr_code),
          //     onTap: () {
          //       QR.to('/qr-scanner');
          //     }),
          // ListTile(
          //   leading: Icon(Icons.lock),
          //   title: Text("Unlock Doors"),
          //   onTap: () {
          //     QR.to('/unlock');
          //   },
          // ),  
          // ListTile(
          //   leading: Icon(Icons.timelapse),
          //   title: Text("Request Time Off"),
          //   onTap: () {
          //     QR.to('/timeoff');
          //   },
          // ),                            
          // ListTile(
          //   leading: Icon(Icons.account_circle_outlined),
          //   title: Text("Change PIN"),
          //   onTap: () {
          //     QR.to('/profile-pin');
          //   },
          //),
                // ListTile(
                //   leading: Icon(Icons.assessment),
                //   title: Text("Time Clock"),
                //   onTap: () {
                //     QR.to('/clockInOut');
                //     // BlocProvider.of<HomeNavBloc>(context)
                //     //     .add(Navigate(page: ScheduleHomePage()));
                //     // Navigator.pop(context);
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.announcement),
                //   title: Text("Rooming"),
                //   onTap: () {
                //     QR.to('/rooming');
                //     // BlocProvider.of<HomeNavBloc>(context)
                //     //     .add(Navigate(page: RoomingHostPage()));
                //     // Navigator.pop(context);
                //   },
                // ),
                          // Divider()                ,
                ListTile(
                  leading: Icon(Icons.assessment),
                  title: Text("Profile"),
                  onTap: () {
                    QR.to('/profile');
                  },
                ),    
          ListTile(
            title: Text("Settings"),
            leading: Icon(Icons.settings),
            onTap: () {
              QR.to('/settings');
            },
          ),                            
                          Divider(),
                          ListTile(
                            title: Text("Logout"),
                            leading: Icon(Icons.exit_to_app),
                            onTap: () {
                              context.read<AuthenticationCubit>().logOutUser();
                            },
                          ),
                          Divider()                ,                        

              ],
            )),
            Container(
              color: Colors.black,
              width: double.infinity,
              height: 0.5,
            ),
            BlocBuilder<ApplicationCubit, ApplicationState>(
              builder: (context, state) {
                List<K2Center> centers = context.read<AuthenticationCubit>().state.centers;
                if (null != state.center) {
                  return ExpansionTile(
                      title: Text("Current Center: ${state.center!.name}"),
                      children: centers.where((c) => c.id != state.center!.id).map((center) 
                      { 
                        return ListTile(title: Text(center.name!),
                        onTap: () {
//                            BlocProvider.of<CurrentCenterBloc>(context).add(ChangeCurrentCenter(centerId: center.id));
                        },);

                      }).toList());
                }
                else
                  return Container(
                    padding: EdgeInsets.all(10),
                    height: 100,
                    child: Text(
                      "V2.0.0",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ));
              },
            ),
          ]));

  //  });
  }
}

class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}
