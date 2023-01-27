// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
// import 'package:k2_flutter_core/k2_flutter_core_services.dart';
// import 'package:k2_flutter_core/preferences/app_preferences.dart';
// import 'package:k2_staff/bloc/current_center/current_center_bloc.dart';
// import 'package:k2_staff/core/services/app_routes.dart';
// import 'package:k2_staff/core/services/service_locator.dart';
// import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
// import 'package:logging/logging.dart';
// import 'package:meta/meta.dart';
// import 'package:qlevar_router/qlevar_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// part 'authentication_event.dart';
// part 'authentication_state.dart';

// class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
//   AuthenticationBloc({required this.centerBloc}) : super(UnauthenticatedState());

//   final CurrentCenterBloc centerBloc;

//   final AuthService? authService = app<AuthService>();

//   /// The [K2User]
//   K2User? user;

//   String? entity;

//   /// [centerMap] holds the list of centers the [K2User] has access to
//   Map<String, String> centerMap = new Map();
  
//   /// Completes with either `true` or `false` whether the user has an active
//   /// cognito session after initialization.
//   Completer<bool> sessionInitialization = Completer<bool>();

//   static AuthenticationBloc of(BuildContext context) =>
//       context.watch<AuthenticationBloc>();

//   static final Logger _log = Logger('InitializeUserSessionEvent');

//   // Future<void> loadCenters() async {
//   //     try {
//   //       GetAllowedCentersResponse _data =
//   //           (await CoreRepository.instance.coreApiService.getAllowedCenters());
//   //       final _centers = _data.centers;
//   //       for (var center in _centers) {
//   //         centerMap[center.id] = center.name;
//   //       }

//   //     } catch (error, stacktrace) {
//   //       _log.severe("Unable to load allowed Centers", stacktrace);
//   //     }    
//   // }

//   @override
//   Stream<AuthenticationState> mapEventToState(AuthenticationEvent event,) async* {
//     if (event is InitializeUserSessionEvent) {
//       yield* _mapInitializeUserSessionToState(event);
//     } else if (event is AuthenticationLoginEvent) {
//       yield* _mapAuthenticationToState(event);
//     }  else if (event is LogoutEvent) {
//       yield* _mapLogOutToState(event);
//     }

// //    yield* event.applyAsync(currentState: state, bloc: this);
//   }

//   Stream<AuthenticationState> _mapInitializeUserSessionToState(InitializeUserSessionEvent event) async* {
// //    if (kIsWeb)
//       await (await SharedPreferences.getInstance()).clear();
//     // else
//     //   await authService!.authActionPruneInvalidUsers();

//      K2User? _currentUser = await authService!.authActionGetCurrentUser();
// // var b = (await SharedPreferences.getInstance()).get("CognitoIdentityServiceProvider.757oom3a8ehsespojlbf5brul2.31ca0843-fbe1-4eb7-b363-1d6e1c4726dc.idToken");
//     if (_currentUser != null) {
//       user = _currentUser;
//       app<AnalyticsService>().logLogin();
//       entity = await user!.getEntityId();
//       K2StaffProfile profile = await user!.getStaffProfile();

//       this.centerBloc.add(InitializeCenters(me: profile));

//       sessionInitialization.complete(true);
//       yield AuthenticatedState(staffProfile: profile);

//       _log.fine('kiosk session initialized');
//     } else {
//       _log.info('not authenticated');
//       sessionInitialization.complete(false);
//       yield UnauthenticatedState();
//     }
//   }

//   Stream<AuthenticationState> _mapAuthenticationToState(AuthenticationLoginEvent event) async* {
//      _log.fine('logging in');
    
//     user = event.user;
//     app<AnalyticsService>().logLogin();
// //    await loadCenters();
//     entity = await user!.getEntityId();
    
//     yield AuthenticatedState(staffProfile: await user!.getStaffProfile());

//     //app<KTNavigator>().pushCenterSelectionScreen();
//     app<AuthenticationGuard>().setSignIn(true);
//     QR.navigator.replaceAll('/home');
//   }

//   Stream<AuthenticationState> _mapLogOutToState(LogoutEvent event) async* {
//     _log.fine('logging out');

//     //await onLogout(bloc);

//     app<AnalyticsService>().logLogout();

//     yield UnauthenticatedState();

//     app<AuthenticationGuard>().setSignIn(false);
//     QR.navigator.replaceAll('/login');
//     //app<KTNavigator>().pushReplacementNamed(LoginScreen.route);

//   }

// }
