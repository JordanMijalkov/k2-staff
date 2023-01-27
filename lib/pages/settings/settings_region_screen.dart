import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:k2_flutter_core/preferences/app_preferences.dart';
import 'package:k2_staff/core/services/app_routes.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_flutter_core/constants/constants.dart' as Constants;

class SettingsRegionScreen extends StatefulWidget {
  @override
  _SettingsRegionScreenState createState() => _SettingsRegionScreenState();
}

class _SettingsRegionScreenState extends State<SettingsRegionScreen> {
  final _appPreferences = app<AppPreferences>();
  final appGuard = app<AuthenticationGuard>();
  var _isUsRegion = false;
  var _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _populatePreferences();
  }

  void _populatePreferences() async {
    setState(() {
      _isUsRegion =
          _appPreferences.getBool(Constants.PREFERENCES_REGION_KEY, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Regions")),
        body: SettingsList(
          sections: [
            SettingsSection(tiles: [
              SettingsTile(
                title: "US",
                trailing: _isUsRegion
                    ? Icon(Icons.check, color: Colors.blue)
                    : Icon(null),
                onPressed: (BuildContext context) {
                  setState(() {
                    _isUsRegion = !_isUsRegion;
                  });

                  Navigator.pop(context, _isUsRegion);
                },
              ),
              SettingsTile(
                title: "AU",
                trailing: !_isUsRegion
                    ? Icon(Icons.check, color: Colors.blue)
                    : Icon(null),
                onPressed: (BuildContext context) {
                  setState(() {
                    _isUsRegion = !_isUsRegion;
                  });

                  Navigator.pop(context, _isUsRegion);
                },
              )
            ]),
          ],
        ),
        bottomNavigationBar: _isSignedIn == false ? null : Container());
  }
}
