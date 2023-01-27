import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_flutter_core/services/message_service.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/profile/bloc/profile_screen/profile_screen_cubit.dart';
import 'package:k2_staff/pages/profile/models/emergency_contact.dart';
import 'package:k2_staff/pages/profile/screens/affiliations_screen.dart';
import 'package:k2_staff/pages/profile/screens/availability_form.dart';
import 'package:k2_staff/pages/profile/screens/change_password_form.dart';
import 'package:k2_staff/pages/profile/screens/change_pin_form.dart';
import 'package:k2_staff/pages/profile/screens/emergency_contact_form.dart';
import 'package:k2_staff/pages/profile/screens/profile_form.dart';


class ProfileTabletHostPage extends StatefulWidget {
  @override
  _ProfileTabletHostPageState createState() => _ProfileTabletHostPageState();
}

class _ProfileTabletHostPageState extends State<ProfileTabletHostPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollViewController;
  late K2StaffProfile _k2staffProfile;

  final MessageService messageService = app<MessageService>();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    _k2staffProfile = context.read<AuthenticationCubit>().state.staffProfile!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileScreenCubit, ProfileScreenState>(
          listenWhen: (previous, current) =>
              previous.profileSaveStatus != current.profileSaveStatus,
          listener: (context, state) {
            if (state.profileSaveStatus == RequestStatus.success) {

              messageService.show('Profile saved');
       // TODO       K2StaffProfileStateContainer.of(context).refreshStaffProfile();

            }
          },
          buildWhen: (previous, current) =>
              previous.emergencyContacts != current.emergencyContacts,
          builder: (context, state) {
            return _buildTabs(context);
          },
    );
  }

  Widget _buildTabs(BuildContext context) {
    Widget buildEmergencyForm() => EmergencyContactForm(
          emergencyContacts:
              context.read<ProfileScreenCubit>().state.emergencyContacts,
          onTapAddAnother: () {
            context.read<ProfileScreenCubit>().addAditionalEmergencyContact(EmergencyContact());
          },
        );

    return Center(
      child: Container(
        width: 850,
        child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: NestedScrollView(
                controller: _scrollViewController,
                headerSliverBuilder:
                    (BuildContext context, bool boxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                    //  backgroundColor: Colors.white,
                      expandedHeight: 0,
                      pinned: true,
                      floating: true,
                      forceElevated: boxIsScrolled,
                      bottom: PreferredSize(
                          preferredSize: Size.fromHeight(48.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: TabBar(
                                isScrollable: true,
                                controller: _tabController,
                                // labelColor:
                                //     Theme.of(context).textTheme.bodyText1!.color,
                                indicatorColor: Theme.of(context).colorScheme.secondary,
                                tabs: <Widget>[
                                  Tab(
                                    text: 'PROFILE',
                                  ),
                                  Tab(
                                    text: 'EMPLOYMENT',
                                  ),
                                ],
                              ))),
                    )
                  ];
                },
                body: TabBarView(
                  children: <Widget>[
                    //  TabletProfileTabLayout(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 8.0),
                          width: 590,
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            body: CustomScrollView(slivers: [
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                ProfileForm(
                                  onSubmit: (profile) {
                                    context.read<ProfileScreenCubit>().saveProfile(profile);
                  
                                  },
                              //   k2staffProfile: _k2staffProfile,
                                ),
                                buildEmergencyForm(),
                              ]))
                            ]),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 8.0),
                          width: 260,
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            body: CustomScrollView(slivers: [
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                _changePassword(context),
                                _changePIN(context),
                              ]))
                            ]),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 8.0),
                          width: 260,
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            body: CustomScrollView(slivers: [
                              SliverList(
                                  delegate: SliverChildListDelegate(
                                      [AffiliationsScreen()]))
                            ]),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 8.0),
                          width: 590,
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            body: CustomScrollView(slivers: [
                              SliverList(
                                  delegate: SliverChildListDelegate(
                                      [AvailabilityForm()]))
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ],
                  controller: _tabController,
                ))),
      ),
    );
  }

  Widget _changePassword(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 36),
                  child: Column(
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.yellow, // button color
                          child: SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(Icons.vpn_key, color: Colors.black)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0, bottom: 4),
                        child: Text("Need to change your"),
                      ),
                      Text("Password?"),
                      Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: ElevatedButton(
                            child: Text("Change Password"),
                            onPressed: () {
 ProfileScreenCubit myCubit = BlocProvider.of<ProfileScreenCubit>(context);
          showDialog(
                  context: context,
                  builder: (context) { 
                    Widget dialog = Dialog(
                    child: 
                    SingleChildScrollView( 
    child: ChangePasswordForm()
  ),
                  );

      // Provide the existing BLoC instance to the new route (the dialog)
      return BlocProvider<ProfileScreenCubit>.value(
        value: myCubit, //
        child: dialog,
      );      
                  }            
                  );
                            },
                          )),
                    ],
                  ),
                ))));
  }

  Widget _changePIN(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(36),
                  child: Column(
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.grey, // button color
                          child: SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(Icons.lock_outline,
                                  color: Colors.black)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0, bottom: 4),
                        child: Text("Need to update your"),
                      ),
                      Text("PIN code?"),
                      Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: ElevatedButton(
                            child: Text("Change PIN"),
                            onPressed: () {
                              ProfileScreenCubit myCubit = BlocProvider.of<ProfileScreenCubit>(context);
          showDialog(
                  context: context,
                  builder: (context) { 
                    Widget dialog = Dialog(
                    child: 
                    SingleChildScrollView( 
    child: ChangePinForm()
  ),
                  );

      // Provide the existing BLoC instance to the new route (the dialog)
      return BlocProvider<ProfileScreenCubit>.value(
        value: myCubit, //
        child: dialog,
      );      
                  }            
                  );
                            },
                          )),
                    ],
                  ),
                ))));
  }

  

}
