import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/repository/authorization/auth_service.dart';
import 'package:k2_flutter_api/repository/authorization/cognito_auth_service.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/login/components/login_form_sso.dart';
import 'package:k2_staff/pages/login/components/login_form_sso_webview.dart';
import '../bloc/login_bloc/login_state.dart';
import 'change_password_page.dart';
import 'forgot_password_form.dart';
import 'join_host_page.dart';
import 'join_screens/join_get_name_page.dart';
import 'login_join_host_page.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';

class LeftLoginColumn extends StatefulWidget {
  final AnimationController? animationController;
  final Animation? animation;

  Future<void> playAnimation() async {
    animationController!.reset();
    animationController!.forward();
  }

  const LeftLoginColumn(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LeftLoginColumnState();
  }
}

class _LeftLoginColumnState extends State<LeftLoginColumn> {
  final AuthService authService = app<CognitoService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.playAnimation(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) { 
        switch (state.runtimeType) {
          case LoginStateForgotPassword:
            {
              return ForgotPasswordForm();
            }
          case LoginStateSSOLogin:
            {
              return LoginFormSSO();
            }
          case LoginStateSSOWebViewLogin:
            {
              String _domain = (state as LoginStateSSOWebViewLogin).domain;
              return Container();
              // LoginFormSSOWebView(
              //   ssoUrl: authService.getSSOAuthorizationUrl(_domain),
              //   redirectUrl: RepositoryServiceConfiguration.COGNITO_REDIRECT_URL,
              // );
            }
          case LoginStateFailure:
            {
              return LoginJoinHostPage();
            }
          case LoginStateNewPasswordRequired:
            {
              return LoginJoinHostPage();
            }
          case LoginStatePasswordChangeRequested:
            {
              return LoginJoinHostPage();
            }
          case LoginStateSwitchUserRequested:
            {
              return LoginJoinHostPage();
            }
          case LoginStateConfirmInviteName:
            {
              final _state = state as LoginStateConfirmInviteName;
              return JoinHostPage(
                  joinStateEmailInviteCodeStatus:
                      _state.joinStateEmailInviteCodeStatus);
            }
          case LoginStateGetInviteName:
            {
              final _state = state as LoginStateGetInviteName;
              return JoinGetNamePage(
                  joinStateEmailInviteCodeStatus:
                      _state.joinStateEmailInviteCodeStatus);
            }
          case LoginStateForgotPasswordConfirmationRequired:
            {
              final _state = state
                  as LoginStateForgotPasswordConfirmationRequired;
              return ChangePasswordForm(
                animation: widget.animation,
                username: _state.username,
              );
            }
          default:
            {
              return LoginJoinHostPage();
            }
        }
          });

      },
    );
  }
}
