import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/home/v2/clock_in_out_success.dart';
import 'package:k2_staff/pages/home/time_clock/time_clock_host.dart';
import 'package:k2_staff/pages/home/home_dashboard.dart';
import 'package:k2_staff/pages/kisi/disclosure_screen.dart';
import 'package:k2_staff/pages/kisi/kisi_home_page.dart';
import 'package:k2_staff/pages/login/login_page.dart';
import 'package:k2_staff/pages/profile/pin/pin_screen.dart';
import 'package:k2_staff/pages/profile/profile_page.dart';
import 'package:k2_staff/pages/profile/screens/change_password_form.dart';
import 'package:k2_staff/pages/profile/screens/profile_form.dart';
import 'package:k2_staff/pages/qr_scanner/qr_screen.dart';
import 'package:k2_staff/pages/settings/settings_screen.dart';
import 'package:k2_staff/pages/splash_screen.dart';
import 'package:k2_staff/pages/time_off_request/time_off_request_history.dart';
import 'package:k2_staff/pages/time_off_request/time_off_request_screen.dart';
import 'package:k2_staff/pages/unlock/unlock.dart';
import 'package:k2_staff/pages/update_time_screen.dart';
import 'package:qlevar_router/qlevar_router.dart';

abstract class Authentication {
  Future<bool> isSignedIn();

  Future<void> setSignIn(bool isSignedIn);
}

class AuthenticationGuard extends QMiddleware implements Authentication {
  bool _signedIn = false;

  @override
  Future<bool> isSignedIn() async {
    return _signedIn;
  }

  @override
  Future<void> setSignIn(bool isSignedIn) async {
    _signedIn = isSignedIn;
    //QR.to('/', ignoreSamePath: false);
  }

  // @override
  // Future<bool> signedIn() async {
  //   return _signedIn = true;
  // }

  @override
  Future<String?> redirectGuard(String path) async =>
      path.contains('login') 
        ? !(await isSignedIn()) ? null : '/home' 
        : await isSignedIn() ? null : '/login' 
      ;
}
class AppRoutes {
  final authGuard = AuthenticationGuard();

  List<QRoute> routes() => [
    QRoute(name: 'Splash', path: '/', builder: () => SplashScreen()),
        QRoute(
            name: 'Settings',
            path: '/settings',
            builder: () => SettingsScreen()),    
    QRoute(name: 'Login', path: '/login', builder: () => LoginPageTablet(isSignedIn: authGuard.setSignIn),
    middleware: [ app<AuthenticationGuard>() ]),
            QRoute(
            name: 'Update Time',
            path: '/updateTime',
            builder: () => UpdateTimeScreen(),
            middleware: [app<AuthenticationGuard>()]),
    QRoute(
            name: 'QR Scanner',
            path: '/qr-scanner',
            builder: () => QRScreen(fromWhere: 'menu'),
            middleware: [app<AuthenticationGuard>()]),
        QRoute(
            name: 'Clock In/Out',
            path: '/clockInOut',
            builder: () => TimeClockHost(),
            middleware: [app<AuthenticationGuard>()]),  
        QRoute(
            name: 'Profile Pin',
            path: '/profile-pin',
            builder: () => PinScreen(),
            middleware: [app<AuthenticationGuard>()]),     
        QRoute(
            name: 'Profile',
            path: '/profile',
            builder: () => ProfilePage(),
            middleware: [app<AuthenticationGuard>()]), 
        QRoute(
            name: 'Profile Form',
            path: '/profile-form',
            builder: () => ProfileScreen(),
            middleware: [app<AuthenticationGuard>()]),     
        QRoute(
            name: 'Change Password',
            path: '/password',
            builder: () => ChangePasswordScreen(),
            middleware: [app<AuthenticationGuard>()]),   
        QRoute(
            name: 'Unlock',
            path: '/unlock',
            builder: () => KisiHomePage(fromWhere: 'menu',),
            middleware: [app<AuthenticationGuard>()]),          
        QRoute(
            name: 'Clock In/Out Success',
            path: '/clockOutSuccess',
            builder: () => ClockInOutSuccessScreen(clockingIn: false,),
            middleware: [app<AuthenticationGuard>()]),       
        QRoute(
            name: 'Clock In Success',
            path: '/clockInSuccess',
            builder: () => ClockInOutSuccessScreen(clockingIn: true,),
            middleware: [app<AuthenticationGuard>()]),                                                           
        // QRoute(
        //     name: 'Schedule',
        //     path: '/schedule',
        //     builder: () => TimeClockHost(),
        //     middleware: [app<AuthenticationGuard>()]),              
        QRoute(
            name: 'Home',
            path: '/home',
            builder: () => HomeDashboardPage(),
            middleware: [app<AuthenticationGuard>()]),      
        QRoute(
            name: 'Disclosure',
            path: '/disclosure',
            builder: () => DisclosureScreen(),
            middleware: [app<AuthenticationGuard>()]),   
        QRoute(
            name: 'Time Off',
            path: '/timeoff',
            builder: () => TimeOffRequestScreen(fromWhere: 'menu',),
            middleware: [app<AuthenticationGuard>()]),      
        QRoute(
            name: 'Time Off History',
            path: '/timeoffHistory',
            builder: () => TimeOffRequestHistoryScreen(),
            middleware: [app<AuthenticationGuard>()]),                                                   
//    QRoute(name: 'Login', path: '/loading', builder: () => LoadingProfilePage()),
    // QRoute.withChild(name: 'Home', path: '/home', 
    //   middleware: [ app<AuthenticationGuard>() ],
    //   builderChild: (c) => HomePage(c),
    //   initRoute: '/profile',
    //   children: [
    //     QRoute(name: 'Home Dashboard', path: '/dashboard', builder: () => HomeDashboardPage()),
    //     QRoute(name: 'Profile', path: '/profile', builder: () => ProfilePage()),
    //     QRoute(name: 'Time Clock', path: '/timeclock', builder: () => TimeClockHost()),
    //     //QRoute(name: 'Clock Out', path: '/clockout', builder: () => ClockOutScreen(), middleware: [ app<AuthenticationGuard>() ]),
    //     QRoute(name: 'Clock In/Out Success', path: '/clockInOutSuccess', builder: () => ClockOutSuccessScreen(), middleware: [ app<AuthenticationGuard>() ]),
    //     QRoute(name: 'Clock In Success', path: '/clockInSuccess', builder: () => ClockInSuccessScreen(), middleware: [ app<AuthenticationGuard>() ]),
    //   ]
    // ),  
   
    //QRoute(name: 'Clock In', path: '/deep/:id((^[0-9]\$)', builder: () => QrClockinScreen()),
//QRoute(name: 'Clock In', path: '/clockIn', builder: () => QrClockinScreen()),
    // QRoute(
    //     name: userPage,
    //     path: '/user/:userId',
    //     builder: () => HomePage(),
    //     children: [
    //       QRoute(name: homePage, path: '/settings', builder: () => SettingsPage()),
    //       QRoute(name: homePage, path: '/profile', builder: () => ProfilePage()),
    //     ]),
    // QRoute(path: '/products/:category(\w)', builder: () => ProductCategory()),
    // QRoute(path: '/products/:id((^[0-9]\$))', builder: () => ProductDetails()),
  ];
}