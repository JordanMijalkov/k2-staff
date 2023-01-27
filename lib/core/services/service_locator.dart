import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'package:k2_flutter_core/k2_flutter_core_preferences.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_flutter_core/services/region_service.dart';
import 'package:k2_staff/core/services/app_routes.dart';
import 'package:k2_staff/core/services/deep_link_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:k2_flutter_core/constants/constants.dart' as Constants;
/// [GetIt] is a simple service locator for accessing services from anywhere
/// in the app.
final GetIt app = GetIt.instance;

/// Adds the services to the [app] service locator.
Future<void> setupServices() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final isDeveloperMode =
      (prefs.getBool(Constants.PREFERENCES_DEVELOPER_MODE_KEY) ?? false);
  final bool? regionCheck = prefs.getBool(Constants.PREFERENCES_REGION_KEY);
  bool isUsRegion = true;

  if (regionCheck == null) {
    DateTime dateTime = DateTime.now();
    // List of AU Time Zone abbreviations from https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations
    if (['ACDT', 'ACST', 'ACWST', 'AEDT', 'AEST', 'AET', 'AWST', 'CWST']
        .contains(dateTime.timeZoneName.toUpperCase())) {
      isUsRegion = false;
    }
    await prefs.setBool(Constants.PREFERENCES_REGION_KEY, isUsRegion);
  } else {
    isUsRegion = regionCheck;
  }


  // Allows us to reassign singletons when app preferences are changed
  app.allowReassignment = true;

  app
    ..registerLazySingleton<MessageService>(() => MessageService())
    ..registerLazySingleton<RegionService>(() => RegionService())
    ..registerLazySingleton<HoneycombService>(() => HoneycombService(isUsRegion ? 'US' : 'AU'))
    ..registerLazySingleton<DeepLinkService>(() => DeepLinkService())
    ..registerLazySingleton<CognitoService>(() => CognitoService(
        cognitoUserPool: isUsRegion
            ? isDeveloperMode
                ? 'us-west-2_pwkzrKVLF'
                : 'us-west-2_cFXDgF3Ue'
            : isDeveloperMode
                ? 'ap-southeast-2_z92IIshad'
                : 'ap-southeast-2_oKjdDFFRP',
        cognitoClientId: isUsRegion
            ? isDeveloperMode
                ? '7nru6na3ptuid8igbmnalvjecc'
                : '757oom3a8ehsespojlbf5brul2'
            : isDeveloperMode
                ? '1i3c6cqu1vqcv2a0u15l6u1083'
                : '596gja2ir2vj76b16fka14bds',
        ssoProviderMap: {
          'kangarootime.com': 'Kangarootime-Azure-AD',
          'adventhealth.com': 'Advent-Health-Microsoft-AD'
        },
        redirectUrl: 'app://'))
    ..registerLazySingleton<K2CoreApiClient>(
        () => K2CoreApiClient(isDeveloperMode
            ? kIsWeb
                ? 'http://localhost:9000/core/api'
                : 'http://10.0.2.2:9000/core/api'
            : isUsRegion
                ? 'https://k2-api.kangarootime.com/core/api'
                : 'https://k2-api.kangarootime.com.au/core/api'))
    ..registerLazySingleton<AuthenticationGuard>(() => AuthenticationGuard())
    ..registerLazySingleton<AppPreferences>(() => AppPreferences())
    ..registerLazySingleton<ThemePreferences>(() => ThemePreferences());
}
