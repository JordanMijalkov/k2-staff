import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_staff/pages/login/bloc/join_request_bloc/bloc.dart';
import 'package:k2_staff/pages/login/bloc/join_screen/bloc.dart';
import 'package:k2_staff/pages/login/components/join_screens/join_create_pin_page.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'join_screens/join_create_password_page.dart';
import 'join_screens/join_get_name_page.dart';
import 'join_screens/join_welcome_page.dart';

class JoinHostPage extends StatelessWidget {
  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;

  JoinHostPage({this.joinStateEmailInviteCodeStatus});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JoinScreenBloc>(
        create: (BuildContext context) => JoinScreenBloc(
            firstname: this.joinStateEmailInviteCodeStatus!.personFirstName,
            lastname: this.joinStateEmailInviteCodeStatus!.personLastName
        ),
        child: BlocBuilder<JoinScreenBloc, JoinScreenState>(
          builder: (context, state) {
            if (state is JoinScreenGetNameState) {
              // This is where we might mutate joinStateEmailInviteCodeStatus
              return JoinGetNamePage(
                  joinStateEmailInviteCodeStatus:
                      this.joinStateEmailInviteCodeStatus);
            }
            if (state is JoinScreenGetPasswordState) {
              // joinStateEmailInviteCodeStatus might have a mutated name from the previous state here
              return JoinCreatePasswordPage(
                  joinStateEmailInviteCodeStatus:
                      state.joinStateEmailInviteCodeStatus);
            }
            if (state is JoinScreenGetPinState) {
              return JoinCreatePinPage(
                // joinStateEmailInviteCodeStatus might have a mutated name from the previous state here
                joinStateEmailInviteCodeStatus:
                    state.joinStateEmailInviteCodeStatus,
                password: state.password,
              );
            }
            if (state is JoinScreenWelcomePageState) {
              // Should have it all one before we get here...
              QR.navigator.replaceAll('/home');
              return CircularProgressIndicator();
              //return JoinOnboardingPage();
            }
            else 
            return Placeholder();
            // Needs a default return!
          },
        ));
  }
}
