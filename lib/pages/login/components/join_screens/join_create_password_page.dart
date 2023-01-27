import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_flutter_core/k2_flutter_core_widgets.dart';
import 'package:k2_staff/pages/login/bloc/join_request_bloc/bloc.dart';
import 'package:k2_staff/pages/login/bloc/join_screen/bloc.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';

class JoinCreatePasswordPage extends StatefulWidget {
  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;
  JoinCreatePasswordPage({this.joinStateEmailInviteCodeStatus});
  @override
  _JoinCreatePasswordPageState createState() => _JoinCreatePasswordPageState();
}

class _JoinCreatePasswordPageState extends State<JoinCreatePasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  FocusNode _focusNodePassword = new FocusNode();
  FocusNode _focusNodeConfirmPassword = new FocusNode();

  bool _passwordsDontMatch = false;
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
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Color
    //    MediaQuery.of(context).platformBrightness
    double offsetPercentage = .925;
    double width = 0;

    return LayoutBuilder(
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
                child: Text("Create Password",
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
                    )
                    ),
              )
            ]),
      ));
    });
  }

  Widget _form() {
    double width;
    return SingleChildScrollView(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
      width = constraint.maxWidth;
//          padding = constraint.maxWidth - width;
      return Center(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text("Now lets set your password",
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 32.0),
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
                        bottomPadding: _passwordsDontMatch ? 6: 34,
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
                        ? Padding(
                          padding: const EdgeInsets.only(bottom: 28.0),
                          child: Text(
                              "Passwords do not match",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                        )
                        : Container(),
                    SizedBox(
                        height: 40.0,
                        width: width,
                        child: RaisedButton(
                          child: Text("Next"),
                          onPressed: _isButtonEnabled()
                              ? () {
                                  BlocProvider.of<JoinScreenBloc>(context)
                                      .add(NavigateToCreatePinPage(
                                          password: _passwordController.text
                                              .trim(),
                                      joinStateEmailInviteCodeStatus: widget.joinStateEmailInviteCodeStatus)
                                  );
                                }
                              : null,
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: SizedBox(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                BlocProvider.of<LoginBloc>(context)
                                    .add(LoginEventDefaultLoginRequest());
                              },
                              child: Text("Cancel",
                                  style: Theme.of(context).textTheme.caption),
                            )
                          ],
                        ))),
                  ])));
    }));
  }

  bool _isButtonEnabled() {
    return (_passwordController.text.length > 6 &&
        (_confirmPasswordController.text == _passwordController.text));
  }
}
