import 'package:flutter/material.dart';
import 'package:k2_flutter_core/components/kt_background.dart';
import 'package:k2_flutter_core/components/size_config.dart';
import 'package:k2_staff/bloc/application/application_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



/// The initial screen that is shown when opening the app.
///
/// After initialization, the [ApplicationBloc] will navigate to either the
/// [LoginScreen] or the [HomeScreen].
class SplashScreen extends StatelessWidget {
  const SplashScreen();

  @override
  Widget build(BuildContext context) {
   // context.read<ApplicationCubit>().setLocale(Localizations.localeOf(context));
    SizeConfig().init(context);

    return KTBackground(
      child: FractionallySizedBox(
          widthFactor: 0.66,
          child: Center(
            child: Column(
              children: [
                Expanded(
                    flex: 4,
                    child: Container(
                      height: SizeConfig.blockSizeVertical! * 10,
                      width: SizeConfig.blockSizeHorizontal! * 40,
                        child: Image.asset('assets/images/splash.png',))),
                          //  fit: BoxFit.fill))),
                Expanded(
                    flex: 1,
                    child: Text(
                      "K2 Staff",
                      style: Theme.of(context).textTheme.headline3,
                    ))
              ],
            ),
          )),
    );
  }
}
