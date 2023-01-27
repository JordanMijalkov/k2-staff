import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:k2_flutter_core/components/kt_error_handler.dart';
import 'package:k2_flutter_core/kt_bloc_observer.dart';
import 'package:k2_staff/bloc/global_bloc_provider.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/kt_app.dart';
//import 'package:k2_staff/kt_error_handler.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
 //configureApp();
 QR.setUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  Bloc.observer = KTBlocObserver();

  await setupServices();

  KTErrorHandler(child: Phoenix(child: GlobalBlocProvider(child: KTApp())));

}
