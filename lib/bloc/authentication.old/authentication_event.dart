// part of 'authentication_bloc.dart';

// @immutable
// abstract class AuthenticationEvent {
//   const AuthenticationEvent();

// //  static final Logger _log = Logger('AuthenticationEvent');

//   /// Executed when a user is authenticated either after a session is retrieved
//   /// automatically after initialization or after a user authenticated manually.
//   ///
//   /// Returns `true` when the initialization was successful.
//   Future<bool> onLogin(AuthenticationCubit bloc) async {
//     final bool initialized = await initializeAuthenticatedUser(bloc);

//     if (initialized) {
//       app<AnalyticsService>().logLogin();
//     }

//     return initialized;
//   }

//   /// Retrieves the [UserData] of the authenticated user and initializes user
//   /// specific preferences.
//   ///
//   /// Returns `true` if the user was able to be initialized.
//   Future<bool> initializeAuthenticatedUser(AuthenticationCubit bloc) async {
//     final String userId = bloc.user!.username!;

//     // initialize the user prefix for the KT preferences
//     app<AppPreferences>().prefix = userId;

//    // final themeMode = app<ThemePreferences>().themeMode;

//     //   // initialize the custom themes for this user
//     //   bloc.themeBloc.loadCustomThemes();

//     //   if (selectedThemeId != -1) {
//     //     _log.fine('initializing selected theme with id $selectedThemeId');

//     //     bloc.themeBloc.add(ChangeThemeEvent(id: selectedThemeId));
//     //   } else {
//     //     _log.fine('no theme selected for the user');
//     //   }
//     // }

//     return bloc.user != null;
//   }

//   /// Logs out of the twitter login and resets the [AuthenticationCubit] session
//   /// data.
//   Future<void> onLogout(AuthenticationCubit bloc) async {
//     // await bloc.twitterLogin?.logOut();

//     // // wait until navigation changed to clear user information to avoid
//     // // rebuilding the home screen without an authenticated user and therefore
//     // // causing unexpected errors
//     // Future<void>.delayed(const Duration(milliseconds: 400)).then((_) {
//     //   bloc.twitterSession = null;
//     //   bloc.authenticatedUser = null;
//     // });

//     // reset the theme to the default theme
// //    bloc.themeBloc.add(const ChangeThemeEvent(id: 0));
//   }

//   // Stream<AuthenticationState> applyAsync({
//   //   AuthenticationState currentState,
//   //   AuthenticationCubit bloc,
//   // });
// }

// /// Used to initialize the kiosk session upon app start.
// ///
// /// If the user has been authenticated before, an active twitter session will be
// /// retrieved and the users automatically authenticates to skip the login
// /// screen. In this case [AuthenticatedState] is yielded.
// ///
// /// If no active twitter session is retrieved, [UnauthenticatedState] is
// /// yielded.
// class InitializeUserSessionEvent extends AuthenticationEvent {
//   const InitializeUserSessionEvent();

//   // static final Logger _log = Logger('InitializeUserSessionEvent');

//   // @override
//   // Stream<AuthenticationState> applyAsync({
//   //   AuthenticationState currentState,
//   //   AuthenticationCubit bloc,
//   // }) async* {
//   //   K2User _currentUser = await bloc.authService.authActionGetCurrentUser();

//   //   if (_currentUser != null) {
//   //     bloc.user = _currentUser;
//   //     _log.info('complete true');
//   //     bloc.sessionInitialization.complete(true);
//   //     yield AuthenticatedState();

//   //     _log.fine('kiosk session initialized');
//   //   } else {
//   //     _log.info('not authenticated');

//   //     _log.info('complete false');
//   //     bloc.sessionInitialization.complete(false);
//   //     yield UnauthenticatedState();
//   //   }
//   // }
// }

// /// Used to authenticate a user.
// class AuthenticationLoginEvent extends AuthenticationEvent {
//   const AuthenticationLoginEvent(this.user);

//   final K2User user;
// }

// /// Used to un-authenticate the currently authenticated user.
// class LogoutEvent extends AuthenticationEvent {
//   const LogoutEvent();

// }
