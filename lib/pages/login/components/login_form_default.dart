import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_flutter_core/k2_flutter_core_widgets.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';
import 'package:qlevar_router/qlevar_router.dart';

class LoginFormDefault extends StatefulWidget {
  const LoginFormDefault({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginFormDefaultState();
}

class _LoginFormDefaultState extends State<LoginFormDefault> {
  // final _usernameController =
      //TextEditingController(text: 'bob.willer@hotmail.com');
  //     TextEditingController(text: 'bob+bbaAnderson@kangarootime.com');
  // final _passwordController = TextEditingController(text: 'Password123!');
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();

  // Default to false when done testing
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _autoValidateUsername = false;
  bool _obscureText = true;

  bool _isSignInButtonEnabled() {
    return _isEmailValid && _isPasswordValid;
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Key _userNameKey = GlobalKey(debugLabel: "Email address");
  final Key _passwordKey = GlobalKey(debugLabel: "password field");
  final MessageService? messageService = app<MessageService>();
  
  @override
  void initState() {
      if (!kReleaseMode) {
        _usernameController.text = 'bob.willer+cap.anson@hotmail.com';
        _passwordController.text = 'Password123!';
  }

    super.initState();

    _usernameController.addListener(() {
      final self = _usernameController;
      setState(() {
        _isEmailValid = FormValidators.validateEmail(self.text);
      });

      if (self.text.length > 3)
        _autoValidateUsername = true;
      else
        _autoValidateUsername = false;
    });

    _passwordController.addListener(() {
      final self = _passwordController;
      setState(() {
        _isPasswordValid = FormValidators.validatePassword(self.text);
      });
    });

    _focusNodeUserName.addListener(() {
      messageService!.dismiss();
    });

    _focusNodePassword.addListener(() {
      messageService!.dismiss();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
//        cubit: BlocProvider.of<LoginBloc>(context),
        builder: (
          BuildContext context,
          LoginState loginState,
        ) {
          return _form(loginState);
        });
  }

  Widget _form(LoginState loginState) {
    double offsetPercentage = .925;
    double width = 0;

    return SingleChildScrollView(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
      width = constraint.maxWidth * offsetPercentage;
      return Center(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextBoxWithHeader(
                        autoFocus: kIsWeb ? true : false,
                        fieldKey: _userNameKey,
                        autoValidate: _autoValidateUsername,
                        labelText: "Email",
                        hintText: "example@kangarootime.com",
                        focusNode: _focusNodeUserName,
                        validator: FormValidators.emailValidator,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: _usernameController,
                        bottomPadding: 16,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _focusNodeUserName, _focusNodePassword);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp("[ \\t]"))
                        ]),
                    TextBoxWithHeader(
                        maxLines: 1,
                        fieldKey: _passwordKey,
                        suffixIcon: GestureDetector(
                          onLongPress: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        labelText: "Password",
                        hintText: "*****",
                        obscureText: _obscureText,
                        onFieldSubmitted: (value) {
                          _focusNodePassword.unfocus();
                          // setState(() {
                          //   testlength = 0;
                          // });
                        },
                        focusNode: _focusNodePassword,
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validator: FormValidators.passwordValidator,
                        textInputAction: TextInputAction.done,
                        bottomPadding: 34,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp("[\\t]"))
                        ]),
                    SizedBox(
                        height: 40.0,
                        width: width,
                        child: ElevatedButton(
                          child: Text("Sign In"),
                          onPressed: _isSignInButtonEnabled()
                              ? () => _buttonPressed()
                              : null,
                        )),
                    // Padding(
                    //     padding: EdgeInsets.only(top: 16.0),
                    //     child: SizedBox(
                    //         height: 40.0,
                    //         width: width,
                    //         child: TextButton(
                    //           child: Text("Sign In with SSO",
                    //           style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color)),
                    //           onPressed: () {
                    //             BlocProvider.of<LoginBloc>(context)
                    //                 .add(LoginEventSSOLoginRequest());
                    //           },
                    //         ))),
                    Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: SizedBox(
                            height: 40.0,
                            width: width,
                            child: TextButton(
                             // padding: EdgeInsets.all(0),
                              onPressed: () {
                                BlocProvider.of<LoginBloc>(context)
                                    .add(LoginEventForgotPassword());
                              },
                              child: Text("Forgot password?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).primaryColor))),
                            ))),
        Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: TextButton(
              onPressed: () {
                QR.to('/settings');
              },
              child: Text("Settings"),
            )),
loginState is LoginStateLoading ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ) : Container()

                  ])));
    }));
  }

  _buttonPressed() {
    setState(() {
    });
    BlocProvider.of<LoginBloc>(context).add(LoginEventLoginRequested(
      username: _usernameController.text.trim().toLowerCase(),
      password: _passwordController.text.trim(),
    ));
  }

  // void _onWidgetDidBuild(Function callback) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     callback();
  //   });
  // }

}
