import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_flutter_core/k2_flutter_core_widgets.dart';
import 'package:k2_staff/core/text_input_formatters.dart';
import 'package:k2_staff/pages/login/bloc/join_request_bloc/bloc.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';

class JoinRequestForm extends StatefulWidget {
  const JoinRequestForm({Key? key}) : super(key: key);

  @override
  _JoinRequestFormState createState() => _JoinRequestFormState();
}

class _JoinRequestFormState extends State<JoinRequestForm>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _usernameController = TextEditingController();
  final _pinController = TextEditingController();

  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePin = new FocusNode();
  BuildContext? scaffoldContext;
  bool _autoValidate = false;

  bool _isEmailValid = false;
  bool _isCodeValid = false;
  bool? _isEmailVerified = false;
  bool? _isCodeVerified = false;
  bool _isReadyToVerify = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isSignInButtonEnabled() {
    return _isEmailValid && _isCodeValid && _isCodeVerified!;
  }

  @override
  void initState() {
    super.initState();
    _usernameController.text = "bobwiller+tomlandry@gmail.com";
    _pinController.text = "RC0VJK";
    _controller = AnimationController(vsync: this);

    _usernameController.addListener(() {
      final self = _usernameController;
      if (self.text.length > 3)
        _autoValidate = true;
      else
        _autoValidate = false;

      setState(() {
        _isEmailValid = FormValidators.validateEmail(self.text);
        if (!_isEmailValid) {
          this._isEmailVerified = false;
        }
        if (self.text.length > 3)
          _autoValidate = true;
        else
          _autoValidate = false;
      });
    });

    _pinController.addListener(() async {
      final self = _pinController;
      setState(() {
        if (self.text.trim().length == 6) {
          this._isCodeValid = true;
        } else {
          this._isCodeValid = false;
          this._isCodeVerified = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _usernameController.dispose();
    _pinController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JoinRequestBloc, JoinRequestState>(
        builder: (context, joinState) {
      // TODO condense these?
      if (joinState is JoinStateHasInvitation) {
        BlocProvider.of<LoginBloc>(context).add(LoginEventJoinFromRequestState(
            joinStateEmailInviteCodeStatus:
                joinState.joinStateEmailInviteCodeStatus));
      }
      if (joinState is JoinStateNeedsRequest) {
        BlocProvider.of<LoginBloc>(context).add(LoginEventJoinFromRequestState(
            joinStateEmailInviteCodeStatus:
                joinState.joinStateEmailInviteCodeStatus));
      }

      _isReadyToVerify = _isEmailValid && _isCodeValid;

      if (joinState is JoinRequestStartedState) {
        _isCodeVerified = false;
        _isEmailVerified = false;
      }

      if (joinState is JoinStateEmailInviteCodeStatus) {
        _isCodeVerified =
            joinState.isInviteCodeVerified; // Have we found a code!
        _isEmailVerified = joinState
            .isEmailVerified; // A profile exists, or we need to request!
        // What if we changed what we typed after a check?
        // We need to change the state, so we can re-fetch
        if (!_isReadyToVerify) {
          BlocProvider.of<JoinRequestBloc>(context)
              .add(JoinEventInitialState());
        }
      }

      // Don't request again, if we have verified...
      // We can request with a unverified email, but always need a center code!
      if (_isReadyToVerify && !_isCodeVerified!) {
        BlocProvider.of<JoinRequestBloc>(context).add(
            JoinEventCheckEmailInviteCode(
                email: _usernameController.text.trim(),
                inviteCode: _pinController.text.trim()));
      }

      return _form(context, joinState);
    });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _form(BuildContext context, JoinRequestState joinState) {
    double offsetPercentage = .925;
    double width = 0;
    return SingleChildScrollView(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
      width = constraint.maxWidth * offsetPercentage;
      return Padding(
          padding: EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextBoxWithHeader(
                      autoValidate: _autoValidate,
                      labelText: "Email",
                      hintText: "example@kangarootime.com",
                      focusNode: _focusNodeUserName,
                      validator: FormValidators.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      //        bottomPadding: 0,
                      controller: _usernameController,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(
                            context, _focusNodeUserName, _focusNodePin);
                      },
                      inputFormatters: [
                        LowerCaseTextFormatter(),
                        FilteringTextInputFormatter.deny(RegExp("[ \\t]"))
                      ]),
//Expanded(child:

                  Container(
                    width: width, //> 350 ? 350 : width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: 4.0, top: 16.0),
                              child: 
                              // Text("Code",
                              //     style:
                              //         Theme.of(context).textTheme.bodyText1)),
                          Container(
                            constraints: BoxConstraints(maxWidth: 345),
                            child: TextBoxWithHeader(
                      autoValidate: _autoValidate,
                      labelText: "Center Code",
                      hintText: "12B4TT",
                      focusNode: _focusNodePin,
//                      validator: FormValidators.emailValidator,
  //                    keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      //        bottomPadding: 0,
                      controller: _pinController,
                      onFieldSubmitted: (term) {
                        _focusNodePin.unfocus();
                        // _fieldFocusChange(
                        //     context, _focusNodeUserName, _focusNodePin);
                      },
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        FilteringTextInputFormatter.deny(RegExp("[ \\t]"))
                      ]),
//                             PinCodeTextField(
//                             appContext: context,
// //                              textCapitalization: TextCapitalization.characters,
//                               length: 6,
//                               controller: _pinController,
//                               focusNode: _focusNodePin,
//                               backgroundColor: Colors.transparent,
//                               obscureText: false,
//                               animationType: AnimationType.fade,
//                               //                        shape: PinCodeFieldShape.box,
//                               textStyle: Theme.of(context).textTheme.bodyText1,
//                               animationDuration: Duration(milliseconds: 300),
//                               onChanged: (_) {},
//                               pinTheme: PinTheme(
//                                 shape: PinCodeFieldShape.box,
//                                 borderWidth: 0.5,
//                                 borderRadius: BorderRadius.circular(5),
//                                 activeColor:
//                                     Theme.of(context).colorScheme.surface,
//                                 // activeColor: _isReadyToVerify
//                                 //     ? _isCodeVerified
//                                 //         ? Colors.green
//                                 //         : Theme.of(context).errorColor
//                                 //     : Theme.of(context).colorScheme.surface,
//                                 inactiveColor:
//                                     Theme.of(context).colorScheme.surface,
//                                 fieldHeight: 45,
//                                 fieldWidth: 40,
//                                 activeFillColor: Colors.black45,
//                               ),
//                             ),
                          )),
                          (joinState == JoinStateEmailInviteCodeStatus() &&
                                  !(joinState as JoinStateEmailInviteCodeStatus)
                                      .isInviteCodeVerified!)
                              ? Text(
                                  "Hmmmm, we can't seem to find that center code",
                                  style: TextStyle(color: Colors.redAccent),
                                )
                              : Container(),
                        ]),
                  ),
//s),
                  Padding(
                      padding: EdgeInsets.only(top: 34.0, bottom: 60),
                      child: SizedBox(
                          height: 40.0,
                          width: width,
                          child: RaisedButton(
                            child: Text("Join Kangarootime"),
                            onPressed: _isSignInButtonEnabled()
                                ? () => {
                                      // Our joinState has all of the info to drive the flow.
                                      // Pass this state to the event...
                                      BlocProvider.of<JoinRequestBloc>(context)
                                          .add(JoinEventSubmitEmailCode(
                                              joinState as JoinStateEmailInviteCodeStatus))
                                      // TODO add some type safety
                                    }
                                : null,
                          ))),
                  // Padding(
                  //     padding: EdgeInsets.only(top: 4.0),
                  //     child: SizedBox(
                  //         child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         FlatButton(
                  //           padding: EdgeInsets.all(0),
                  //           onPressed: () {
                  //              BlocProvider.of<JoinRequestBloc>(context)
                  //                  .add(JoinCenterButtonPressed());
                  //           },
                  //           child: Text("Don't Have a Code?",
                  //               style:
                  //                   Theme.of(context).textTheme.caption),
                  //         )
                  //       ],
                  //     ))),
                ]),
          ));
    }));
  }
}
