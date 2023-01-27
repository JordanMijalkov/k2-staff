import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/repository/authorization/auth_service.dart';
import 'package:k2_flutter_api/repository/authorization/cognito_auth_service.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_flutter_core/k2_flutter_core_widgets.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';
import 'package:k2_staff/pages/login/kt_onboarding_scaffold.dart';

class LoginFormSSO extends StatefulWidget {
  LoginFormSSO({Key? key}) : super(key: key);

  @override
  _LoginFormSSOState createState() {
    return _LoginFormSSOState();
  }
}

class _LoginFormSSOState extends State<LoginFormSSO> {
  final _formKey = GlobalKey<FormState>();
  String? emailAddress;
  final AuthService authService = app<CognitoService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (
      BuildContext context,
      LoginState loginState,
    ) {
      return KtOnboardingScaffold(
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextBoxWithHeader(
                                onSaved: (value) {
                                  emailAddress = value;
                                },
                                labelText: "Email Address",
                                hintText: "example@kangarootime.com",
                                validator: FormValidators.emailValidator,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                bottomPadding: 16,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp("[ \\t]"))
                                ]),
                            SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                    child: Text("Sign In"),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        if (emailAddress != null) {
                                          String domain = emailAddress!.split('@')[1];
                                          if (authService.getSSOAuthorizationUrl(domain) != null) {
                                            BlocProvider.of<LoginBloc>(context).add(
                                                LoginEventSSOLoginWebViewRequest(
                                                    domain: domain));
                                          } else {
                                            // Flushbar<bool>(
                                            //   title: "Login Error",
                                            //   margin: EdgeInsets.all(8),
                                            //   borderRadius: 8,
                                            //   flushbarStyle: FlushbarStyle.FLOATING,
                                            //   reverseAnimationCurve: Curves.decelerate,
                                            //   forwardAnimationCurve: Curves.elasticOut,
                                            //   leftBarIndicatorColor: Colors.redAccent,
                                            //   duration: Duration(seconds: 5),
                                            //   onTap: (Flushbar f) {
                                            //     f.dismiss(true);
                                            //   },
                                            //   icon: Icon(
                                            //     Icons.error_outline,
                                            //     size: 28.0,
                                            //     color: Colors.red,
                                            //   ),
                                            //   message: 'SSO is not configured for your organization. Did you mean to sign in without SSO?',
                                            // )..show(context).then((result) {});
                                          }
                                        }
                                      }
                                    })),
                            Padding(
                                padding: EdgeInsets.only(top: 16.0),
                                child: SizedBox(
                                    height: 40.0,
                                    child: FlatButton(
                                      child: Text("Sign In without SSO"),
                                      onPressed: () {
                                        BlocProvider.of<LoginBloc>(context).add(
                                            LoginEventDefaultLoginRequest());
                                      },
                                    ))),
                          ])))));
    });
  }
}
