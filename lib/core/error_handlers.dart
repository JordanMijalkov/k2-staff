import 'package:k2_flutter_core/services/message_service.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('NetworkErrorHandler');

/// Does nothing with the error except logging it.
///
/// Used when an error can just be ignored.
void silentErrorHandler(dynamic error) {
  _log.info('silently ignoring error', error);
}

/// Handles the [error] from a request.
///
/// An error message is shown in a [K2Message].
///
/// If [fallbackMessage] is not `null`, it is used in place of a generic error
/// message if the error wasn't handled.
void apiErrorHandler(dynamic error) {
  _log.info('handling api error', error);

  final MessageService messageService = app<MessageService>();

  String? message;

  

  message ??= 'An unexpected error occurred';

  messageService.show(message);
}