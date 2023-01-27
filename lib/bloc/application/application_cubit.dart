import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'package:k2_flutter_core/k2_flutter_core_preferences.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/services/app_routes.dart';
import 'package:k2_staff/core/services/deep_link_service.dart';
import 'package:k2_staff/core/services/service_locator.dart';
//import 'package:launchdarkly_flutter/launchdarkly_flutter.dart';
import 'package:logging/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';
//import 'package:timezone/browser.dart' as tz;
part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit(
    this.authenticationBloc,
  ) : super(ApplicationState(K2AppSettings(
            true,
            'k2-api.kangarootime.com/core/api',
            'us-west-2_cFXDgF3Ue',
            '757oom3a8ehsespojlbf5brul2',
            '1fa0ecffed4146898a17aad063672e86@o429824.ingest.sentry.io/5380552',
            'en_US')));

  final AuthenticationCubit authenticationBloc;
   final RegionService regionService = app<RegionService>();
  //final CoreApiService coreApiService = app<K2CoreApiClient>();
   final HoneycombService honeycombService = app<HoneycombService>();
  
  static ApplicationCubit of(BuildContext context) =>
      context.watch<ApplicationCubit>();

  static final Logger _log = Logger('InitializeEvent');
  String _disclosureKey = '';
  // final ChangelogPreferences? changelogPreferences = app<ChangelogPreferences>();
  // final AppDeviceInfo? ktInfo = app<AppDeviceInfo>();

  Future<void> initializeApp() async {
    
    _log.fine('start common initialization');

    initLogger();

    // need the device info before we continue with updating the system ui
//    await app<AppDeviceInfo>().initialize();

    await Future.wait<void>(<Future<void>>[
      app<CognitoService>().initialize(),
      app<HoneycombService>().initialize(),
      app<AppPreferences>().initialize(),
      app<RegionService>().initialize()
    ]);

    final bool authenticated = await _userInitialization();
    final String defaultLocale = regionService.defaultLocale();
    emit(state.copyWith(
        status: ApplicationStatus.initialized, appLocale: defaultLocale));

    if (authenticated) {
      app<AuthenticationGuard>().setSignIn(true);
      this.authenticationBloc.navigate();
      // emit(state.copyWith(
      //   staffMember: this.authenticationBloc.state.staffProfile));

      // DateTime startDate = new DateTime.now().toLocal();
      // int offset = await NTP.getNtpOffset(localTime: startDate);

      // Duration diff = Duration(milliseconds: offset);
      // _log.fine('Device Time Difference: ${diff.toString()}');

      // if (diff.inSeconds > 45)
      //   QR.navigator.replaceAll('/updateTime');
      // else
      //  QR.navigator.replaceAll('/home');
    } else {
      // prevent showing changelog dialog for this version
//      changelogPreferences.setToCurrentShownVersion();
      // navigate to login screen
      app<AuthenticationGuard>().setSignIn(false);
      QR.navigator.replaceAll('/login');
    }
  }

  /// Waits for the [AuthenticationBloc] to complete the session
  /// initialization and handles user specific initialization.
  ///
  /// Returns whether the uses is authenticated.
  Future<bool> _userInitialization() async {
    _log.fine('start user initialization');

    // start session initialization
    authenticationBloc.initializeUserSession();

    // wait for the session to initialize
    final bool authenticated =
        await authenticationBloc.sessionInitialization.future;
    return authenticated;
  }

  
  Future<void> seenDisclosureScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
        _disclosureKey =
              this.authenticationBloc.state.staffProfile!.fullName +
                  'disclosureScreen';
    prefs.setBool(_disclosureKey, false);
    QR.navigator.replaceAll('/home');
  }
}
