// import 'package:logging/logging.dart';

// final Logger _log = Logger('AppConfig');

// These are loaded by repository_service_config....

// const String httpProtocol = String.fromEnvironment('HTTP_PROTOCOL');
// const String k2ApiUrl = String.fromEnvironment('K2_API_URL');
// const String cognitoClientId = String.fromEnvironment('COGNITO_USER_POOL_ID');
// const String cognitoUserPoolId = String.fromEnvironment('COGNITO_CLIENT_ID');

const String sentryDsn = String.fromEnvironment('sentry_dsn');
/// Initializes the [data] from the environment parameters.
///
/// If the configuration is invalid, [data] will be `null`.
///
/// The parameters can be set using the
/// `--dart-define=key=value`
/// flags when running the app.
///
/// Required parameters include:
/// * COGNITO_USER_POOL_ID
/// * COGNITO_CLIENT_ID
///
/// Optional parameters include:
/// * sentry_dsn (Error reporting service)
/// * HTTP_PROTOCOL (defaults to https)
/// * K2_API_URL (defaults to k2-api.kangarootime.com/core/api)
///
/// For example:
/// ```
/// flutter run \
/// --dart-define=HTTP_PROTOCOL=https \
/// --dart-define=K2_API_URL=k2-api.kangarootime.com/core/api \
/// --dart-define=COGNITO_USER_POOL_ID=us-west-2_your pool Id \
/// --dart-define=COGNITO_CLIENT_ID=your client id
/// ```


// void validateAppConfig() {
//   if (httpProtocol.isEmpty ||
//      (k2ApiUrl == null || k2ApiUrl.isEmpty) ||
//      (cognitoClientId == null || cognitoClientId.isEmpty) ||
//      (cognitoUserPoolId == null || cognitoUserPoolId.isEmpty)) {
//       _log.severe('Invalid Configuration Information.\n'
//           'Make sure to provide your Cognito Pool & \n'
//           'Client ID. '
//           'For example:\n'
//           'flutter run \\\n'
//           '--dart-define=COGNITO_USER_POOL_ID=us-west-2_your pool Id \\\n'
//           '--dart-define=COGNITO_CLIENT_ID=your client id');
//   }
// }
