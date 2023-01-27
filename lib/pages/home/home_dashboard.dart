import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_staff/bloc/application/application_cubit.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
import 'package:k2_staff/core/widgets/scaffold/staff_app_drawer.dart';
//import 'package:k2_staff/pages/home/bloc/schedule/bloc.dart';
import 'package:k2_staff/pages/home/cubit/schedule_cubit.dart';
import 'package:k2_staff/pages/home/widgets/home_dashboard_cards/clock_status_card.dart';
import 'package:k2_staff/pages/home/widgets/home_dashboard_cards/greeting_card.dart';
import 'package:k2_staff/pages/home/widgets/home_dashboard_cards/schedule.dart';
import 'package:k2_staff/pages/home/widgets/home_dashboard_cards/scheduleMonth.dart';
import 'package:k2_staff/pages/home/widgets/home_dashboard_cards/schedule_display_card.dart';
import 'package:k2_staff/pages/home/widgets/home_dashboard_cards/shift_card.dart';
import 'package:k2_staff/pages/home/widgets/home_dashboard_cards/time_off_status_card.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:k2_staff/pages/home/widgets/home_dashboard_cards/home_dashboard_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../kisi/kisi_home_page.dart';
import '../qr_scanner/qr_screen.dart';
import '../time_off_request/time_off_request_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    Dashboard(),
    DashBScheCalendar(), //DashBSchedule(),
    TimeOffRequestScreen(fromWhere: 'tab',),
    QRScreen(fromWhere: 'tab'),
    KisiHomePage(fromWhere: 'tab',),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: _pages.elementAt(_selectedIndex),
      // ),
      body: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(
                  246, 247, 251, 1), // Theme.of(context).colorScheme.surface,
              // border: Border.all(
              //   color: Colors.grewhiteen,
              // ),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: _pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/Home.png"),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/Schedule.png"),
            ),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/Time Off.png"),
            ),
            label: 'Time Off',
          ),
          BottomNavigationBarItem(
            // icon: ImageIcon(
            //   AssetImage("assets/images/Message.png"),
            // ),
            icon: Icon(
              Icons.qr_code_scanner,
              // color: Colors.green,
              // size: 30.0,
            ),
            label: 'QR Scan',
          ),
          BottomNavigationBarItem(
            // icon: ImageIcon(
            //   AssetImage("assets/images/Settins.png"),
            // ),
            icon: Icon(
              Icons.lock_open,
              // color: Colors.green,
              // size: 30.0,
            ),
            label: 'Doors',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

//  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];

  void _onRefresh() async {
    // monitor network fetch
    await context.read<ScheduleCubit>().init();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    //  await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length+1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
// return Scaffold(
//       body: BlocProvider(
//         create: (context) =>
//             ScheduleCubit(authCubit: context.read<AuthenticationCubit>())..init(),
//         child: BlocBuilder<ScheduleCubit, ScheduleState>(
//           builder: (context, state) {
//           return SmartRefresher(
//             enablePullDown: true,
//             enablePullUp: true,
//             header: WaterDropHeader(),
//             footer: CustomFooter(
//               builder: (context, mode){
//                 Widget body;
//                 if(mode==LoadStatus.idle){
//                   body =  Text("pull up load");
//                 }
//                 else if(mode==LoadStatus.loading){
//                   body =  CircularProgressIndicator();
//                 }
//                 else if(mode == LoadStatus.failed){
//                   body = Text("Load Failed!Click retry!");
//                 }
//                 else if(mode == LoadStatus.canLoading){
//                     body = Text("release to load more");
//                 }
//                 else{
//                   body = Text("No more Data");
//                 }
//                 return Container(
//                   height: 55.0,
//                   child: Center(child:body),
//                 );
//               },
//             ),
//             controller: _refreshController,
//             onRefresh: _onRefresh,
//             onLoading: _onLoading,
//             child: _phoneDashboard(context)
//             // ListView.builder(
//             //   itemBuilder: (c, i) => Card(child: Center(child: Text(items[i]))),
//             //   itemExtent: 100.0,
//             //   itemCount: items.length,
//             // ),
//           );
//         }
//       ),
//     ));

    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        if (state.status == ScheduleStateStatus.initialized)
          return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (context, mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    // body = Text("pull up load");
                    body = Text("");
                  } else if (mode == LoadStatus.loading) {
                    body = CircularProgressIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    // body = Text("release to load more");
                    body = Text("");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: _phoneDashboard(context)
              // ListView.builder(
              //   itemBuilder: (c, i) => Card(child: Center(child: Text(items[i]))),
              //   itemExtent: 100.0,
              //   itemCount: items.length,
              // ),
              );

        //   _phoneDashboard(context);
        else
          return Center(
              child: SizedBox(
                  width: 64, height: 64, child: CircularProgressIndicator()));
        // FutureBuilder<bool>(
        //   future: callAsyncFetch(context.read<ScheduleCubit>()),
        //   builder: (context, AsyncSnapshot<bool> snapshot) {
        //     if (snapshot.hasData)
        //       return _phoneDashboard(context);

        //       // ScreenTypeLayout.builder(
        //       //   tablet: (BuildContext context) =>
        //       //       _tabletDashboard(context), //, state, _openTimeEntry),
        //       // mobile: (BuildContext context) =>
        //       //     _phoneDashboard(context), // state, _openTimeEntry),
        //        //       );
        //     else
        //       return CircularProgressIndicator();
        //   }
        // );
      },
    );
    //     }));
    //   }
    // );
  }

  Widget _tabletDashboard(BuildContext context) {
    //, ScheduleState state, K2TimeEntry? openTimeEntry) {

    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      HomeDashboardCard(child: HomeGreetingCard()),
      // HomeDashboardCard(
      //     child: CurrentStatusCard(
      //         openTimeEntry: openTimeEntry,
      //         onTap: () {
      //           // BlocProvider.of<HomeNavBloc>(context)
      //           //     .add(Navigate(page: KioskPage()));
      //         })),
      // HomeDashboardCard(
      //     child: ScheduleDisplayCard(
      //   state: state,
      // )),
      // HomeDashboardCard(
      //   child: TimeOffStatusCard(),
      // ),
      // HomeDashboardCard(
      //     child: ShiftCard(
      //         openTimeEntry: openTimeEntry,
      //         onTap: () {
      //           // BlocProvider.of<HomeNavBloc>(context)
      //           //     .add(Navigate(page: KioskPage()));
      //         })),
    ]));

    // return SingleChildScrollView(
    //           child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //         ])
    // );
  }

  Widget _phoneDashboard(BuildContext context) {
    //, ScheduleState state, K2TimeEntry? openTimeEntry) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        HomeDashboardCard(child: HomeGreetingCard()),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: ClockStatusCard(
            //openTimeEntry: openTimeEntry,
            onTap: () {
              QR.to('/qr-scanner');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: ScheduleDisplayCard(),
        )
      ]),
    ));
  }
}

class DashBSchedule extends StatefulWidget {
  @override
  State<DashBSchedule> createState() => _DashBScheduleState();
}

class _DashBScheduleState extends State<DashBSchedule> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(246, 247, 251, 1),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 229, 235, 255),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                unselectedLabelColor: Color.fromARGB(
                  255,
                  142,
                  142,
                  147,
                ),
                labelColor: Color.fromARGB(255, 21, 121, 198),
                indicatorColor: Color.fromRGBO(0, 0, 0, 0.1),
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: EdgeInsets.all(0),
                indicatorPadding: EdgeInsets.all(0),
                indicatorWeight: 1.0,
                tabs: [
                  _individualTab('assets/images/calendar.png'),
                  _individualTab('assets/images/list.png'),
                  _individualTab('assets/images/history.png'),
                  // Tab(
                  //   icon: ImageIcon(
                  //     AssetImage("assets/images/calendar.png"),
                  //   ),
                  // ),
                  // Tab(
                  //   icon: ImageIcon(
                  //     AssetImage("assets/images/list.png"),
                  //   ),
                  // ),
                  // Tab(
                  //   icon: ImageIcon(
                  //     AssetImage("assets/images/history.png"),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DashBScheCalendar(),
            DashBScheCalendar(),
            Icon(Icons.call_missed_outgoing, size: 350),
          ],
        ),
      ),
    );
  }

  Widget _individualTab(String imagePath) {
    return Container(
      height: 50 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.all(0),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
              right: BorderSide(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  width: 1,
                  style: BorderStyle.solid))),
      child: Tab(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              child: Container(
                  child: Center(
                    child: ImageIcon(AssetImage(imagePath)),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.1)))))),
        ]),
      ),
    );
  }
}

class DashBScheCalendar extends StatefulWidget {
  @override
  State<DashBScheCalendar> createState() => _DashBScheCalendarState();
}

class _DashBScheCalendarState extends State<DashBScheCalendar> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await context.read<ScheduleCubit>().init();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    //  await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length+1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        if (state.status == ScheduleStateStatus.initialized)
          return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (context, mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    // body = Text("pull up load");
                    body = Text("");
                  } else if (mode == LoadStatus.loading) {
                    body = CircularProgressIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    // body = Text("release to load more");
                    body = Text("");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: _phoneDashboard(context));
        else
          return Center(
              child: SizedBox(
                  width: 64, height: 64, child: CircularProgressIndicator()));
      },
    );
    //     }));
    //   }
    // );
  }

  Widget _phoneDashboard(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: ScheduleMonthWidget(),
        )
      ]),
    ));
  }
}

class HomeDashboardPage extends StatelessWidget {
  Widget build(BuildContext context) {
    //context.read<ApplicationCubit>().scanForBeacons();

    // K2StaffProfile? _k2staffProfile =
    //     context.read<AuthenticationCubit>().state.staffProfile;

    return KTScaffold(
        drawer: StaffAppDrawer(),
        body: BlocProvider(
          create: (context) =>
              ScheduleCubit(authCubit: context.read<AuthenticationCubit>())
                ..init(),
          child: BottomNavBar(), // Dashboard(),
        ));

    // BlocProvider<ScheduleBloc>(
    //     create: (BuildContext context) => ScheduleBloc()
    //       ..add(ScheduleEventInitial(k2staffProfile: _k2staffProfile)),
    //     child: KTScaffold(drawer: StaffAppDrawer(), body: Dashboard())
    // BlocConsumer<ScheduleBloc, ScheduleState>(
    //   listener: (context, state) {
    //   }, builder: (context, state) {
    // return Placeholder();
    //   }
    // )

    // Padding(
    //     padding: const EdgeInsets.all(18.0),
    //     child: BlocConsumer<ScheduleBloc, ScheduleState>(
    //         listener: (context, state) {
    //       if (state.runtimeType == SelectedScheduleState) {
    //         SelectedScheduleState currentState =
    //             (state as SelectedScheduleState);
    //         if (currentState?.k2user != null &&
    //             currentState?.shiftSchedule == null)
    //           context.read<ScheduleBloc>().add(ScheduleUpdateDateRangeEvent(
    //               k2user: (state as SelectedScheduleState).k2user));
    //       }
    //     }, builder: (context, state) {
    //       if (state != null) {
    //         switch (state.runtimeType) {
    //           case SelectedScheduleState:
    //             {
    //               final _state = state as SelectedScheduleState;
    //               _openTimeEntry = _state?.timeEntries?.firstWhere(
    //                   (element) => element.timeOut == null,
    //                   orElse: () => null);
    //               debugPrint('${_openTimeEntry == null}');
    //               break;
    //             }
    //           default:
    //             break;
    //         }
    //       }
    //       return
    //                     ScreenTypeLayout.builder(
    //         tablet: (BuildContext context) =>
    //             _tabletDashboard(context, state, _openTimeEntry),
    //         mobile: (BuildContext context) =>
    //             _phoneDashboard(context, state, _openTimeEntry),
    //       );
    //     }))
    //     );
  }
}
