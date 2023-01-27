import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:k2_flutter_api/repository/authorization/auth_storage.dart';
import 'package:k2_flutter_core/preferences/app_preferences.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/services/app_routes.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/settings/settings_region_screen.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:k2_flutter_core/constants/constants.dart' as Constants;
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _appPreferences = app<AppPreferences>();
  final appGuard = app<AuthenticationGuard>();

  var _isUsRegion = false;
  var _isDeveloperMode = false;
  var _isSignedIn = false;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _populatePreferences();
    _checkUserIsSignedIn();

    if (!kIsWeb) _getPackageInfo();
  }

  Future<void> _getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  void _populatePreferences() async {
    await app<AppPreferences>().initialize();
    setState(() {
      _isUsRegion =
          _appPreferences.getBool(Constants.PREFERENCES_REGION_KEY, false);
      _isDeveloperMode = _appPreferences.getBool(
          Constants.PREFERENCES_DEVELOPER_MODE_KEY, false);
    });
  }

  void _checkUserIsSignedIn() async {
    bool isSignedIn = await appGuard.isSignedIn();
    setState(() {
      _isSignedIn = isSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    return Container(
        child: Center(
      child: Column(
        children: <Widget>[
          Expanded(
              child: SettingsList(
            backgroundColor: Colors.white,
            sections: [
              _isSignedIn
                  ? SettingsSection(
                      title: "Common",
                      tiles: [
                        SettingsTile(
                          title: 'Region',
                          subtitle: _isUsRegion ? 'US' : 'AU',
                          leading: Icon(Icons.language),
                          onPressed: (context) async {
                            final result = await Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        SettingsRegionScreen()));

                            setState(() {
                              _isUsRegion = result;
                            });
                          },
                        ),
                        SettingsTile.switchTile(
                          title: 'Developer Mode',
                          subtitle: _isDeveloperMode ? 'Enabled' : 'Disabled',
                          switchValue: _isDeveloperMode,
                          leading: Icon(Icons.computer),
                          onToggle: (bool value) {
                            setState(() {
                              _isDeveloperMode = value;
                            });
                          },
                        ),
                        SettingsTile(
                          title: 'Clear Local Cache',
                          subtitle: 'Warning, this will log you out.',
                          leading: Icon(Icons.delete),
                          onPressed: (BuildContext context) async {
                            await _deleteCacheDir();
                            await _deleteAppDir();

                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();

                            final AuthStorage _authStorage =
                                AuthStorage.instance;
                            _authStorage.clear();

                            context.read<AuthenticationCubit>().logOutUser();
                          },
                        ),
                        SettingsTile(
                            title: 'Sign out',
                            leading: Icon(Icons.exit_to_app),
                            onPressed: (context) => context
                                .read<AuthenticationCubit>()
                                .logOutUser())
                      ],
                    )
                  : SettingsSection(
                      title: "Common",
                      tiles: [
                        SettingsTile(
                          title: 'Region',
                          subtitle: _isUsRegion ? 'US' : 'AU',
                          leading: Icon(Icons.language),
                          onPressed: (context) async {
                            final result = await Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        SettingsRegionScreen()));

                            setState(() {
                              _isUsRegion = result ?? _isUsRegion;
                            });
                          },
                        ),
                        SettingsTile.switchTile(
                          title: 'Developer Mode',
                          subtitle: _isDeveloperMode ? 'Enabled' : 'Disabled',
                          switchValue: _isDeveloperMode,
                          leading: Icon(Icons.computer),
                          onToggle: (bool value) {
                            setState(() {
                              _isDeveloperMode = value;
                            });
                          },
                        ),
                        SettingsTile(
                          title: 'Clear Local Cache',
                          leading: Icon(Icons.delete),
                          onPressed: (BuildContext context) async {
                            await _deleteCacheDir();
                            await _deleteAppDir();

                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();

                            final AuthStorage _authStorage =
                                AuthStorage.instance;
                            _authStorage.clear();

                            context.read<AuthenticationCubit>().logOutUser();
                          },
                        ),                        
                      ],
                    ),
              SettingsSection(
                title: 'Version Info',
                tiles: [
                  SettingsTile(
                      leading: Icon(Icons.build),
                      title: 'Version',
                      subtitle: _packageInfo.version),
                  SettingsTile(
                    leading: Icon(Icons.build),
                    title: 'Build Number',
                    subtitle: _packageInfo.buildNumber,
                  )
                ],
              )
            ],
          )),
          Divider(),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
            child: SizedBox(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40),
                    ),
                    child: Text("Save"),
                    onPressed: () async {
                      _appPreferences.setBool(
                          Constants.PREFERENCES_DEVELOPER_MODE_KEY,
                          _isDeveloperMode);
                      _appPreferences.setBool(
                          Constants.PREFERENCES_REGION_KEY, _isUsRegion);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 20),
                          content: Text("Settings saved",
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.green));

                      var authCubit = context.read<AuthenticationCubit>();

                      if (await appGuard.isSignedIn()) {
                        await authCubit.logOutUser();
                        setupServices();
                        Phoenix.rebirth(context);
                      } else {
                        setupServices();
                        Phoenix.rebirth(context);
                      }
                    })),
          ),
        ],
      ),
    ));
  }

  Future<void> _deleteCacheDir() async {
    Directory tempDir = await getTemporaryDirectory();

    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }
  }
}
