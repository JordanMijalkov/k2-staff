import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_flutter_core/k2_flutter_core_widgets.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/login/bloc/change_password/bloc.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';

class ChangePasswordForm extends StatefulWidget {
  final Animation? animation;
  final String? username;

  ChangePasswordForm({Key? key, required this.animation, this.username})
      : super(key: key);

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final MessageService? messageService = app<MessageService>();

  final _verificationCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  FocusNode _focusNodePassword = new FocusNode();
  FocusNode _focusNodeVerificationCode = new FocusNode();
  FocusNode _focusNodeConfirmPassword = new FocusNode();

  bool _isCodeValid = false;
  bool _passwordsDontMatch = false;
  bool _obscureText0 = true;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      if (_passwordController.text.length > 3 &&
          _confirmPasswordController.text.length > 3 &&
          (_passwordController.text != _confirmPasswordController.text)) {
        if (!_passwordsDontMatch)
          setState(() {
            _passwordsDontMatch = true;
          });
      } else if (_passwordsDontMatch)
        setState(() {
          _passwordsDontMatch = false;
        });
    });

    _confirmPasswordController.addListener(() {
      if (_passwordController.text.length > 3 &&
          _confirmPasswordController.text.length > 3 &&
          (_passwordController.text != _confirmPasswordController.text)) {
        if (!_passwordsDontMatch)
          setState(() {
            _passwordsDontMatch = true;
          });
      } else if (_passwordsDontMatch)
        setState(() {
          _passwordsDontMatch = false;
        });
    });

    _verificationCodeController.addListener(() { 
          setState(() {
            if (_verificationCodeController.text.length == 6) 
              _isCodeValid = true;
            else
              _isCodeValid = false;
          });
      
    });
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _codeEntered() {
    BlocProvider.of<LoginBloc>(context).add(LoginEventDefaultLoginRequest());
    messageService!.dismiss();
  }

  void _blocListener(BuildContext context, ChangePasswordState state) {
    if (state is ChangePasswordStateError ||
        state is ChangePasswordStateSuccess) {
      String? error;
      if (state is ChangePasswordStateError) error = state.error;
      state is ChangePasswordStateSuccess
          ? messageService!.show(
              "Your password has been changed.  Click the Login button to continue.",
              action: SnackBarAction(
                  label: "Login", onPressed: () => _codeEntered()),
              isSticky: true)
          : messageService!.show(
              "There was an error processing your request: $error",
              isSticky: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    double offsetPercentage = .925;
    double width = 0;

    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: _blocListener,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraint) {
          width = constraint.maxWidth * offsetPercentage;
          double offsetwidth = constraint.maxWidth - width;
          return Container(
              child: Padding(
            padding: EdgeInsets.only(
                top: offsetwidth, left: offsetwidth, right: offsetwidth),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 51,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.fill)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 8.0),
                    child: Text("Change Password",
                        style: Theme.of(context).textTheme.headline1),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Card(
                          margin: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0)),
                          ),
                          elevation: 4,
                          child: _form(),
                        )),
                  )
                ]),
          ));
        }));
    // );
  }

  Widget _form() {
    double width;
    return SingleChildScrollView(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
      width = constraint.maxWidth;
      return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
          builder: (context, state) {
        return Center(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 24),
                      child: Text("Verify your identity",
                          style: Theme.of(context).textTheme.headline1),
                    ),

TextBoxWithHeader(
                            labelText: "Verification Code",
                            hintText: "*****",
                            keyboardType: TextInputType.number,
                            obscureText: _obscureText0,
                            focusNode: _focusNodeVerificationCode,
                            controller: _verificationCodeController,
                            bottomPadding: 16,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(context, _focusNodeVerificationCode,
                                  _focusNodePassword);
                            },
                            suffixIcon: GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  _obscureText0 = !_obscureText0;
                                });
                              },
                              onTap: () {
                                setState(() {
                                  _obscureText0 = !_obscureText0;
                                });
                              },
                              child: Icon(_obscureText0
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                        //    validator: FormValidators.passwordValidator,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp("[\\t]"))
                            ]),













                    // Padding(
                    //     padding: const EdgeInsets.only(bottom: 4.0),
                    //     child: Text("Verification Code",
                    //         style: Theme.of(context).textTheme.bodyText1)),
                    // PinCodeTextField(
                    //   appContext: context,
                    //   length: 6,
                    //   controller: _verificationCodeController,
                    //   animationType: AnimationType.fade,
                    //   animationDuration: Duration(milliseconds: 300),
                    //   enableActiveFill: true,
                    //   focusNode: _focusNodeVerificationCode,
                    //   backgroundColor: Colors.transparent,
                    //   //obsecureText: false,
                    //   //                        shape: PinCodeFieldShape.box,
                    //   textStyle: Theme.of(context).textTheme.bodyText1,
                    //   //    pinTheme: MediaQuery.of(context).platformBrightness == Brightness.dark ? darkPinTheme : lightPinTheme,

                    //   pinTheme: PinTheme(
                    //     shape: PinCodeFieldShape.box,
                    //     borderRadius: BorderRadius.circular(5),
                    //     // activeColor:
                    //     //     joinState == JoinRequestState.invalidCenter
                    //     //         ? Colors.redAccent
                    //     //         : Colors.green,
                    //     inactiveColor: Colors.grey,
                    //     fieldHeight: 45,
                    //     fieldWidth: 40,
                    //     activeFillColor: Colors.black45,
                    //   ),
                    //   //              borderRadius: BorderRadius.circular(5),
                    //   // activeColor:
                    //   //     joinState == JoinRequestState.invalidCenter
                    //   //         ? Colors.redAccent
                    //   //         : Colors.green,
                    //   // inactiveColor: Colors.grey,
                    //   // fieldHeight: 45,
                    //   // fieldWidth: 40,
                    //   // borderWidth: 1,
                    //   onChanged: (pin) {
                    //     setState(() {
                    //       pin.length == 6
                    //           ? this._isCodeValid = true
                    //           : this._isCodeValid = false;
                    //     });
                    //   },
                    // ),
                    Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: TextBoxWithHeader(
                            labelText: "New Password",
                            hintText: "*****",
                            obscureText: _obscureText1,
                            focusNode: _focusNodePassword,
                            controller: _passwordController,
                            bottomPadding: 16,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(context, _focusNodePassword,
                                  _focusNodeConfirmPassword);
                            },
                            suffixIcon: GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  _obscureText1 = !_obscureText1;
                                });
                              },
                              onTap: () {
                                setState(() {
                                  _obscureText1 = !_obscureText1;
                                });
                              },
                              child: Icon(_obscureText1
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            validator: FormValidators.passwordValidator,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp("[\\t]"))
                            ])),
                    TextBoxWithHeader(
                        labelText: "Confirm Password",
                        hintText: "*****",
                        obscureText: _obscureText2,
                        focusNode: _focusNodeConfirmPassword,
                        controller: _confirmPasswordController,
                        textInputAction: TextInputAction.done,
                        //   bottomPadding: 34,
                        onFieldSubmitted: (value) {
                          _focusNodePassword.unfocus();
                        },
                        validator: FormValidators.passwordValidator,
                        suffixIcon: GestureDetector(
                          onLongPress: () {
                            setState(() {
                              _obscureText2 = !_obscureText2;
                            });
                          },
                          onTap: () {
                            setState(() {
                              _obscureText2 = !_obscureText2;
                            });
                          },
                          child: Icon(_obscureText2
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp("[\\t]"))
                        ]),
                    _passwordsDontMatch
                        ? Text(
                            "Passwords do not match",
                            style: TextStyle(color: Colors.redAccent),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 34.0),
                      child: SizedBox(
                          height: 40.0,
                          width: width,
                          child: ElevatedButton(
                            child: Text("Change Password"),
                            onPressed: _changePasswordButtonEnabled()
                                ? () => _buttonPressed()
                                : null,
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                            width: width,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              BlocProvider.of<LoginBloc>(
                                                      context)
                                                  .add(
                                                      LoginEventDefaultLoginRequest());
                                            });
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ))),
                                ]))),
                    Container(
                        width: width,
                        child: Center(
                            child: Padding(
                                padding: EdgeInsets.only(top: 24.0),
                                child: state is ChangePasswordStateLoading
                                    ? CircularProgressIndicator()
                                    : Container())))
                  ],
                )));
      });
    }));
  }

  _buttonPressed() {
    BlocProvider.of<ChangePasswordBloc>(context)
        .add(ChangePasswordEventConfirmationRequested(
      username: widget.username,
      verificationCode: _verificationCodeController.text.trim(),
      newPassword: _passwordController.text.trim(),
    ));
  }

  _changePasswordButtonEnabled() {
    return (_passwordController.text.length > 6 &&
        _isCodeValid &&
        (_confirmPasswordController.text == _passwordController.text));
  }
}
