import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_flutter_core/k2_flutter_core_widgets.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/login/bloc/forgot_password/bloc.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final MessageService? messageService = app<MessageService>();

  final _usernameController = TextEditingController();
  bool _isEmailValid = false;
  bool _autoValidate = false;

  FocusNode _focusNodeUserName = new FocusNode();

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(() {
      final self = _usernameController;
      setState(() {
        _isEmailValid = FormValidators.validateEmail(self.text);
        if (self.text.length > 3)
          _autoValidate = true;
        else
          _autoValidate = false;
      });
    });

    _focusNodeUserName.addListener(() {
      messageService!.dismiss();
    });
  }

  _enterCode() {
    BlocProvider.of<LoginBloc>(context).add(LoginEventChangePasswordCodeSent(
        username: _usernameController.text.trim()));
    messageService!.dismiss();
  }

  void _blocListener(BuildContext context, ForgotPasswordState state) {
    if (state is FPStateCodeSentError || state is FPStateCodeSent) {
      String? error;
      if (state is FPStateCodeSentError) error = state.error;
      state is FPStateCodeSent
          ? messageService!.show(
              "Your verification code has been sent to your email.  Click the Enter Code button when you have received it.",
              action: SnackBarAction(
                  label: "Enter Code", onPressed: () => _enterCode()),
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

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
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
                    padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: Text("Verify your identity",
                        style: Theme.of(context).textTheme.headline1),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 28.0),
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
  }

  Widget _form() {
    double width;
    return SingleChildScrollView(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
      width = constraint.maxWidth;
      return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
        return Center(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: TextBoxWithHeader(
                            autoValidate: _autoValidate,
                            labelText:
                                "Please enter your email address to proceed",
                            hintText: "example@kangarootime.com",
                            focusNode: _focusNodeUserName,
                            validator: FormValidators.emailValidator,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction
                                .done, // This makes no sense to me, but .done and .none doesn't dismiss the keyboard :(
                            controller: _usernameController,
                            bottomPadding: 34,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp("[ \\t]"))
                            ])),
                    SizedBox(
                        height: 40.0,
                        width: width,
                        child: ElevatedButton(
                          child: Text("Send Verification Code"),
                          onPressed: _isEmailValid
                              ? () =>
                                  BlocProvider.of<ForgotPasswordBloc>(context)
                                      .add(FPEventSendCodeRequest(
                                          email:
                                              _usernameController.text.trim()))
                              : null,
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 27.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _resendCode(state),
                              Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          //      _forgotPasswordBloc.add(Reset());
                                          BlocProvider.of<LoginBloc>(context).add(
                                              LoginEventDefaultLoginRequest());
                                        });
                                      },
                                      child: Text(
                                        "Cancel",
                                      ))),
                            ])),
                    Container(
                        width: width,
                        child: Center(
                            child: Padding(
                                padding: EdgeInsets.only(top: 24.0),
                                child: state is FPStateSendingCode
                                    ? CircularProgressIndicator()
                                    : null)))
                  ],
                )));
      });
    }));
  }

  _resendCode(ForgotPasswordState state) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text("Didn't receive code? ",
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
      TextButton(
          onPressed: _isEmailValid
              ? () {
                  if (state is FPStateCodeSent) {
                    setState(() {
                      BlocProvider.of<ForgotPasswordBloc>(context).add(
                          FPEventSendCodeRequest(
                              email: _usernameController.text.trim()));
                    });
                  }
                }
              : null,
          child: Text(
            "  Send Again",
          ))
    ]);
  }
}
