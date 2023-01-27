import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:k2_staff/core/widgets/scaffold/login_scaffold.dart';
import 'package:ntp/ntp.dart';
import 'package:qlevar_router/qlevar_router.dart';

class UpdateTimeScreen extends StatelessWidget {
  const UpdateTimeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 353;
    return LoginScaffold(
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 34),
            width: 425,
            //  height: 390,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Time Mismatch',
                  style: Theme.of(context).textTheme.headline1,
                ),
                Container(
                  width: width,
                  child: Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text(
                        "The current time on this device is out of sync with actual time.  Please open device settings and reset.",
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SizedBox(
                      height: 40.0,
                      width: 375,
                      child: TextButton(
                        child: Text("Open Device Settings"),
                        onPressed: () => AppSettings.openDateSettings(),
                        // QR.to('/settings')
                        // context.read<SelectPersonBloc>()
                        //     .add(SelectPersonEventCancel()),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: SizedBox(
                      height: 40.0,
                      width: width,
                      child: ElevatedButton(
                        child: Text("Retry"),
                        onPressed: () async {
                          DateTime startDate = new DateTime.now().toLocal();
                          int offset =
                              await NTP.getNtpOffset(localTime: startDate);

                          Duration diff = Duration(milliseconds: offset);

                          if (diff.inSeconds < 10)
                            QR.navigator.replaceAll('/selectCenter');
                        },
                      )),
                ),
              ],
            )));
  }
}
