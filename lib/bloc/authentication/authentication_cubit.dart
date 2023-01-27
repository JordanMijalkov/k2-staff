import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:k2_flutter_api/api/responses/GetAllowedCentersResponse.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'package:k2_staff/core/services/app_routes.dart';
import 'package:k2_staff/core/services/deep_link_service.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:logging/logging.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationState());

   final AuthService authService = app<CognitoService>();
   final CoreApiService coreApiService = app<K2CoreApiClient>();
   final HoneycombService honeycombService = app<HoneycombService>();
  // final DeepLinkService deepLinkService = app<DeepLinkService>();
  
  /// Completes with either `true` or `false` whether the user has an active
  /// cognito session after initialization.
  Completer<bool> sessionInitialization = Completer<bool>();
  
  // static AuthenticationCubit of(BuildContext context) =>
  //     context.watch<AuthenticationCubit>();  

  static final Logger _log = Logger('InitializeUserSessionEvent');
  String _disclosureKey = '';

  Future<List<K2Center>> loadCenters() async {
      try {
        GetAllowedCentersResponse _data =
            (await coreApiService.getAllowedCenters());

        return _data.centers.where((center) => center.deactivatedAt == null && center.deletedAt == null).toList();            

      } catch (error, stacktrace) {
        List pairs = [];
        pairs.add({'error', error.toString()});
              HoneycombEvent a = honeycombService.createEvent(
          'getAllowedCenters', 'root', pairs, null);
        await authService.authActionLogOut();
        await authService.authActionPruneInvalidUsers();
        a.closeHoneyCombEvent();
        QR.navigator.replaceAll('/login');
        
        //_log.severe("Unable to load allowed Centers", stacktrace);
      }    
      return [];
  }
  
  Future<void> initializeUserSession() async {
    emit(state.copyWith(status: AuthenticationStatus.awaiting));
    // await authService.authActionLogOut();
    // await authService.authActionPruneInvalidUsers();

    // final AuthStorage _authStorage = AuthStorage.instance;
    // _authStorage.clear();
    // if (kIsWeb)
    //   await (await SharedPreferences.getInstance()).clear();
    // else
    //   await authService.authActionPruneInvalidUsers();

    await authService.authActionPruneInvalidUsers();

     K2User? _currentUser = await authService.authActionGetCurrentUser();
    
    if (_currentUser != null) {

//      app<AnalyticsService>().logLogin();
      List<K2Center> centers = await loadCenters();
      late K2StaffProfile profile;
      try {
        profile = await _currentUser.getStaffProfile();
      }
      catch(e) {
        List pairs = [];
        pairs.add({'error', e.toString()});
              HoneycombEvent a = honeycombService.createEvent(
          'getStaffProfile', 'root', pairs, null);        
        await authService.authActionLogOut();
        await authService.authActionPruneInvalidUsers();
        a.closeHoneyCombEvent();
        QR.navigator.replaceAll('/login');        
      }
      
    String? entity;
    try {
       entity = await _currentUser.getEntityId();
    }
    catch(e) {
        List pairs = [];
        pairs.add({'error', e.toString()});
              HoneycombEvent a = honeycombService.createEvent(
          'getEntityId-1', 'root', pairs, null);             
        await authService.authActionLogOut();
        await authService.authActionPruneInvalidUsers();
        a.closeHoneyCombEvent();
        QR.navigator.replaceAll('/login');  
    }

      sessionInitialization.complete(true);

      emit(state.copyWith(
        status: AuthenticationStatus.authenticated,
        user: _currentUser,
        entityId: entity!,
        staffProfile: profile,
        centers: centers));

      _log.fine('staff session initialized');
    } else {
      _log.info('not authenticated');
      sessionInitialization.complete(false);
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    }
  }

  Future<void> logInUser(K2User user) async {
    emit(state.copyWith(status: AuthenticationStatus.awaiting));
    _log.fine('logging in');
//    app<AnalyticsService>().logLogin();
    List<K2Center> centers = await loadCenters();
    
    String? entity;
    try {
       entity = await user.getEntityId();
    }
    catch(e) {
        List pairs = [];
        pairs.add({'error', e.toString()});
              HoneycombEvent a = honeycombService.createEvent(
          'getEntityId-2', 'root', pairs, null);             
        await authService.authActionLogOut();
        await authService.authActionPruneInvalidUsers();
        a.closeHoneyCombEvent();
        QR.navigator.replaceAll('/login');  
    }
    
    
      late K2StaffProfile profile;
      try {
        profile = await user.getStaffProfile();
      }
      catch(e) {
        List pairs = [];
        pairs.add({'error', e.toString()});
              HoneycombEvent a = honeycombService.createEvent(
          'getStaffProfile2', 'root', pairs, null);             
        await authService.authActionLogOut();
        await authService.authActionPruneInvalidUsers();
        a.closeHoneyCombEvent();
        QR.navigator.replaceAll('/login');        
      }
    
    emit(state.copyWith(
        status: AuthenticationStatus.authenticated,
        user: user,
        entityId: entity!,
        staffProfile: profile,
        centers: centers));

    app<AuthenticationGuard>().setSignIn(true);
    navigate();
    // DateTime startDate = new DateTime.now().toLocal();
    // int offset = await NTP.getNtpOffset(localTime: startDate);

    // Duration diff = Duration(milliseconds: offset);
    // _log.fine('Device Time Difference: ${diff.toString()}');

    // if (diff.inSeconds > 45)
    //   QR.navigator.replaceAll('/updateTime');
    // else
     // QR.navigator.replaceAll('/home');
  }
          
  Future<void> logOutUser() async {     
    _log.fine('logging out');   
    
    authService.authActionLogOut();
//    app<AnalyticsService>().logLogout();

    emit(state.copyWith(status: AuthenticationStatus.unauthenticated));

    app<AuthenticationGuard>().setSignIn(false);
    QR.navigator.replaceAll('/login');      
  }

  void navigate() async {
            AuthStorage storage = AuthStorage.instance;

        if (Platform.isAndroid) {
          _disclosureKey =
              this.state.staffProfile!.fullName +
                  'disclosureScreen';

          SharedPreferences prefs = await SharedPreferences.getInstance();

          if (prefs.getBool(_disclosureKey) ?? true)
            QR.navigator.replaceAll('/disclosure');
           else {
        // //    Check for Deep Links
        //     if (!await deepLinkService.deepActionCheckInCheckOut(null)) {
            
                 QR.navigator.replaceAll('/home');
             }
        //   }
        // } else {
        //   // Check for Deep Links
        //   if (!await deepLinkService.deepActionCheckInCheckOut(null)) {
        //       QR.navigator.replaceAll('/home');
        //   }

        }
        else
          QR.navigator.replaceAll('/home');
  }  
  
}
