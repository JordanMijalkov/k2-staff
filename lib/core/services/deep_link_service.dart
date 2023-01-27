import 'dart:convert';

import 'package:k2_flutter_api/repository/authorization/auth_storage.dart';
import 'package:k2_staff/models/deep_link_data.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:k2_flutter_core/constants/constants.dart' as Constants;

class DeepLinkService {
  Future<bool> deepActionCheckInCheckOut(String? link) async {
    if (link != null) {
      Uri? uri = Uri.tryParse(link);

      // Perform check on URI path for possible future deep links
      if (uri != null &&
          uri.path.contains(Constants.DEEP_LINK_STAFF_TIMECLOCK_PATH)) {
        QR.params.ensureExist(Constants.DEEP_LINK_CENTER_ID,
            initValue: uri.queryParameters[Constants.DEEP_LINK_CENTER_ID],
            keepAlive: true);

        QR.params.ensureExist(Constants.DEEP_LINK_TIMESTAMP,
            initValue: uri.queryParameters[Constants.DEEP_LINK_TIMESTAMP],
            keepAlive: true);

        AuthStorage storage = AuthStorage.instance;
        await Future.wait([
          storage
              .removeItem(Constants.AUTH_STORAGE_DEEP_LINK_DATA_TIMECLOCK_KEY)
        ]);

        // Handle back-arrow from checkInOut screen
   //     QR.navigator.replaceAll('/home');
        QR.to('/clockInOut');

        return true;
      } else {
        return false;
      }
    } else {
      // Check for Deep Link
      AuthStorage storage = AuthStorage.instance;
      String? authStorageDeepLinkData = await storage
              .getItem(Constants.AUTH_STORAGE_DEEP_LINK_DATA_TIMECLOCK_KEY) ??
          null;

      if (authStorageDeepLinkData != null) {
        var parsedJson = jsonDecode(authStorageDeepLinkData);
        var checkInCheckOutData = CheckInCheckOut.fromJson(parsedJson);

        QR.params.ensureExist(Constants.DEEP_LINK_CENTER_ID,
            initValue: checkInCheckOutData.centerId, keepAlive: true);

        QR.params.ensureExist(Constants.DEEP_LINK_TIMESTAMP,
            initValue: checkInCheckOutData.timestamp, keepAlive: true);

        await Future.wait([
          storage
              .removeItem(Constants.AUTH_STORAGE_DEEP_LINK_DATA_TIMECLOCK_KEY)
        ]);

        // Handle back-arrow from checkInOut screen
        QR.navigator.replaceAll('/home');
        QR.to('/clockInOut');

        return true;
      }
    }

    return false;
  }
}
