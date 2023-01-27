import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/api/core_api_service.dart';
import 'package:k2_flutter_api/api/k2_core_api_client.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
//import 'package:k2_staff/pages/profile/bloc/phone_screen/bloc.dart';
import 'package:k2_staff/pages/profile/bloc/profile_screen/profile_screen_cubit.dart';
import 'package:k2_staff/pages/profile/screens/affiliations_screen.dart';
import 'package:k2_staff/pages/profile/screens/availability_form.dart';
import 'package:k2_staff/pages/profile/screens/emergency_contact_form.dart';
import 'package:k2_staff/pages/profile/screens/security_form.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'profile_form.dart';

class ProfileMenuPhone extends StatelessWidget {

  final CoreApiService coreApiService = app<K2CoreApiClient>();

  Future<K2StaffProfile> getCurrentUserStaffProfile() async {
    
    return await coreApiService.getMe().then((value) {
      final json = value!.data;
      return K2StaffProfile.fromJson(json!['getMe']);
    });
  }

  @override
  Widget build(BuildContext context) {

    final tiles = [
      //Tile(Icon(Icons.person_outline), "Acount Information", "Manage your name and address",  '/profile-form'),
      // ProfileForm(
      //                             onSubmit: (profile) {
      //                               context.read<ProfileScreenCubit>().saveProfile(profile);
      //                             },
      //                           //  k2staffProfile: context.read<AuthenticationCubit>().state.staffProfile!,)
      //                            )),
      Tile(Icon(Icons.lock_outline, color: Colors.yellow,), "Password", "Change your password", '/password'), // SecurityForm()),
      Tile(Icon(Icons.security, color: Colors.blueAccent,), "Pin", "Change your pin", '/profile-pin'), // SecurityForm()),
      // Tile(Icon(Icons.location_on, color: Colors.orangeAccent,), "Availability", "Now, with more work...", ''), // AvailabilityForm()),
      // Tile(Icon(Icons.work, color: Colors.blueAccent,), "Affiliations", "Where u been?...", ''), // AffiliationsScreen()),
      // Tile(Icon(Icons.local_hospital,color: Colors.redAccent,), "Emergency Contact", "Who do we call when you get maimed?", ''), // EmergencyContactForm()),
    ];

    return KTScaffold(title: 'Profile', body:Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: List.generate(tiles.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical:8.0),
                            child: ListTile(
                                onTap: () {
                                  //BlocProvider.of<PhoneScreenBloc>(context).add(Navigate(page: tiles[index].page));
                                  QR.to(tiles[index].page);
                                },
                                leading: tiles[index].icon,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0),
                                      child: Text(
                                        tiles[index].title,
                                        style:
                                        Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ),
                                    Text(
                                      tiles[index].subTitle,
                                      style: Theme.of(context).textTheme.caption,
                                    )
                                  ],
                                ),
                                trailing: ClipOval(
                                    child: Material(
                                        color: Colors.purple, // button color
                                        child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Icon(
                                              Icons.chevron_right,
                                              color: Colors.white,
                                            ))))),
                          );
                        }),
                      ).toList())),
            ],
          ),
        ),
      ],
    ));

  }
}

class Tile {
  Icon icon;
  String title;
  String subTitle;
  String page;

  Tile(this.icon, this.title, this.subTitle, this.page);
}
