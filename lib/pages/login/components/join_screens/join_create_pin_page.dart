import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_core/components/form_validators.dart';
import 'package:k2_flutter_core/widgets/textbox_with_header.dart';
//import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:k2_staff/pages/login/bloc/join_request_bloc/bloc.dart';
import 'package:k2_staff/pages/login/bloc/join_screen/bloc.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';

class JoinCreatePinPage extends StatefulWidget {
  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;
  final String? password;
  JoinCreatePinPage({this.joinStateEmailInviteCodeStatus, this.password});

  @override
  _JoinCreatePinPageState createState() => _JoinCreatePinPageState();
}

class _JoinCreatePinPageState extends State<JoinCreatePinPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  FocusNode _focusNodePassword = new FocusNode();
  FocusNode _focusNodeConfirmPassword = new FocusNode();

  bool _passwordsMatch = false;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      if (_passwordController.text.length == 4 &&
          (_passwordController.text == _confirmPasswordController.text)) {
        setState(() {
          _passwordsMatch = true;
        });
      } else
        setState(() {
          _passwordsMatch = false;
        });
    });

    _confirmPasswordController.addListener(() {
      if (_passwordController.text.length == 4 &&
          (_passwordController.text == _confirmPasswordController.text)) {
        setState(() {
          _passwordsMatch = true;
        });
      } else
        setState(() {
          _passwordsMatch = false;
        });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  
  @override
  Widget build(BuildContext context) {
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
                    child: Text("Create PIN",
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
    });
  }

  Widget _form() {
    double width;
    return SingleChildScrollView(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
      width = constraint.maxWidth;
      return Center(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          "Once you’re in the app. You will sometimes need to use a PIN. Create a memorable PIN.",
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Container(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(
                      bottom: 4.0, top: 16.0),
                  child: TextBoxWithHeader(
                      labelText: "PIN",
                      hintText: "****",
                      maxLength: 4,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced,
                      obscureText: _obscureText1,
                      focusNode: _focusNodePassword,
                      controller: _passwordController,
                      keyboardType: TextInputType.number,
                      bottomPadding: 16,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(
                            context,
                            _focusNodePassword,
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
                      validator:
                          FormValidators.passwordValidator,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp("[\\t]"))
                      ])),
              Padding(
                  padding:
                      EdgeInsets.only(bottom: 4.0, top: 16.0),
                  child: TextBoxWithHeader(
                      labelText: "Confirm PIN",
                      hintText: "****",
                      maxLength: 4,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced,
                      obscureText: _obscureText2,
                      focusNode: _focusNodeConfirmPassword,
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {
                        _focusNodePassword.unfocus();
                      },
                      validator:
                          FormValidators.passwordValidator,
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
                        FilteringTextInputFormatter.deny(
                            RegExp("[\\t]"))
                      ])),                                
                                // Padding(
                                //     padding:
                                //         EdgeInsets.only(bottom: 4.0, top: 16.0),
                                //     child: 
                                //     Text("PIN",
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .bodyText1)),
                                
                                
                                
                                
  //                               PinCodeTextField(
  //                                 appContext: context,
  //                           backgroundColor: Colors.transparent,                                  
  //                                 length: 4,
  //                                 obscuringCharacter: '*',
  //                                 // controller: _pinController,
  //                                 // focusNode: _focusNodePin,
  //                                 obscureText: true,
  //                                 animationType: AnimationType.fade,
  //                //                 shape: PinCodeFieldShape.box,
  //                                 textStyle:
  //                                     Theme.of(context).textTheme.bodyText1,
  //                                 animationDuration:
  //                                     Duration(milliseconds: 300),
  //                //                 borderRadius: BorderRadius.circular(5),
  //                                 textInputAction: TextInputAction.next,
  //                         pinTheme: PinTheme(
  //   shape: PinCodeFieldShape.box,
  //   borderRadius: BorderRadius.circular(5),
  //   activeColor: Theme.of(context).colorScheme.onSurface,
  //                           // activeColor: _isReadyToVerify
  //                           //     ? _isCodeVerified
  //                           //         ? Colors.green
  //                           //         : Colors.redAccent
  //                           //     : Colors.grey,
  //   inactiveColor: Theme.of(context).colorScheme.onSurface,
  //   fieldHeight: 45,
  //   fieldWidth: 40,
  //   activeFillColor: Colors.transparent,
  // ),
  //                                 onChanged: (pin) {
  //                                   setState(() {
  //                                     if (pin.trim().length == 4) {
  //                                       this._isCodeValid = true;
  //                                       this._pin = pin;
  //                                     } else
  //                                       this._isCodeValid = false;
  //                                   });
  //                                 },
  //                               ),




                                // Padding(
                                //     padding:
                                //         EdgeInsets.only(bottom: 4.0, top: 16.0),
                                //     child: Text("Confirm PIN",
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .bodyText1)),
//                                 PinCodeTextField(
//                                   appContext: context,
//                                   length: 4,
//                             backgroundColor: Colors.transparent,
//                             obscuringCharacter: '*',
//                                   // controller: _pinController,
//                                   // focusNode: _focusNodePin,
//                                   obscureText: true,
//                                   animationType: AnimationType.fade,
// //                                  shape: PinCodeFieldShape.box,
//                                   textStyle:
//                                       Theme.of(context).textTheme.bodyText1,
//                                   animationDuration:
//                                       Duration(milliseconds: 300),
//   //                                borderRadius: BorderRadius.circular(5),
//                                   textInputAction: TextInputAction.next,
//                           pinTheme: PinTheme(
//     shape: PinCodeFieldShape.box,
//     borderRadius: BorderRadius.circular(5),
//     activeColor: Theme.of(context).colorScheme.onSurface,
//                             // activeColor: _isReadyToVerify
//                             //     ? _isCodeVerified
//                             //         ? Colors.green
//                             //         : Colors.redAccent
//                             //     : Colors.grey,
//     inactiveColor: Theme.of(context).colorScheme.onSurface,
//     fieldHeight: 45,
//     fieldWidth: 40,
//     activeFillColor: Colors.transparent,
//   ),
//                                   onChanged: (pin) {
//                                     setState(() {
//                                       this._confirmPin = pin;
//                                     });
//                                   },
//                                 ),
                                              (!_passwordsMatch &&
                      _passwordController.text.length == 4 &&
                      _confirmPasswordController.text.length ==
                          4)
                        ? Padding(
                          padding: const EdgeInsets.only(bottom: 28.0),
                          child: Text(
                              "PINs do not match",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                        )
                        : Container(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 34.0),
                        child: SizedBox(
                            height: 40.0,
                            width: width,
                            child: ElevatedButton(
                              child: Text("Next"),
                              onPressed: _isButtonEnabled()
                                  ? () {
                                      BlocProvider.of<JoinScreenBloc>(context)
                                          .add(NavigateToWelcomePage(
                                        pin: _passwordController.text,
                                        password: widget.password,
                                        joinStateEmailInviteCodeStatus: widget.joinStateEmailInviteCodeStatus
                                      ));
                                    }
                                  : null,
                            ))),
                    Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: SizedBox(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              
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
    return (_passwordsMatch &&
        _passwordController.text.length == 4 &&
        _confirmPasswordController.text.length == 4);
  }
}
