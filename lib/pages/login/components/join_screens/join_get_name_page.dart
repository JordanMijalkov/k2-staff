import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:k2_flutter_core/k2_flutter_core_widgets.dart';
import 'package:k2_staff/pages/login/bloc/join_request_bloc/bloc.dart';
import 'package:k2_staff/pages/login/bloc/join_screen/bloc.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';
import 'join_invite_sent_dialog.dart';

class JoinGetNamePage extends StatefulWidget {

  final JoinStateEmailInviteCodeStatus? joinStateEmailInviteCodeStatus;

  JoinGetNamePage({this.joinStateEmailInviteCodeStatus});

  @override
  _JoinGetNamePageState createState() => _JoinGetNamePageState();
}

class _JoinGetNamePageState extends State<JoinGetNamePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  FocusNode _focusNodeFirstName = new FocusNode();
  FocusNode _focusNodeLastName = new FocusNode();

  final _fnKey = GlobalKey<FormFieldState>();
  final _lnKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.joinStateEmailInviteCodeStatus?.personFirstName ?? '';
    _lastNameController.text = widget.joinStateEmailInviteCodeStatus?.personLastName ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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

    return BlocBuilder<JoinRequestBloc, JoinRequestState>(
        builder: (context, joinState) {
      return BlocListener<JoinRequestBloc, JoinRequestState>(
         // cubit: BlocProvider.of<JoinRequestBloc>(context),
          listener: (BuildContext context, JoinRequestState state) {
            if (state is JoinRequestInvitationSentState) {
              showDialog(
                  context: context,
                  builder: (context) => JoinInviteSentDialog(
                    centerName: state.response!.data!['requestToJoinCenterViaCode']['primaryCenter']['name']
                  ));
            }
          },
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
                          child: Text(
                              joinState is JoinStateNeedsRequest
                                  ? "Enter your name"
                                  : "Confirm Name",
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
                              topRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            ),
                          ),
                          elevation: 4,
                          child: _form(joinState),
                        )
                              
                              
//                               Container(
//                                   decoration: BoxDecoration(
// //                                      color: Colors.white,
//                                       borderRadius: BorderRadius.vertical(
//                                           top: Radius.circular(20))),
//                                   child: _form(joinState))
                                  ),
                        )
                      ]),
                ));
          }));
    });
  }

  Widget _form(JoinRequestState joinState) {
    double width;
    String headerText =
        "We need a few more things to get you going. Let's start with making sure we have your name correct";
    String buttonText = "Next";

    if (joinState is JoinStateNeedsRequest) {
      buttonText = "Submit Request";
      headerText = "We just need your name in order to submit your request";
    }

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
                        padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                        child: Text(headerText,
                            style: Theme.of(context).textTheme.bodyText1)),
                    TextBoxWithHeader(
                        controller: _firstNameController,
                        focusNode: _focusNodeFirstName,
                        fieldKey: _fnKey,
                        labelText: "First Name",
                        textInputAction: TextInputAction.next,
                        bottomPadding: 16,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _focusNodeFirstName, _focusNodeLastName);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp("[\\t]"))
                        ]),
                    TextBoxWithHeader(
                        fieldKey: _lnKey,
                        focusNode: _focusNodeLastName,
                        controller: _lastNameController,
                        textInputAction: TextInputAction.done,
                        bottomPadding: 34,
                        onFieldSubmitted: (value) {
                          _focusNodeLastName.unfocus();
                        },
                        labelText: "Last Name",
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp("[\\t]"))
                        ]),
                    SizedBox(
                        height: 40.0,
                        width: width,
                        child: RaisedButton(
                          child: Text(buttonText),
                          onPressed: _isButtonEnabled()
                              ? () {
                                  if (joinState is JoinStateNeedsRequest) {
                                    BlocProvider.of<JoinRequestBloc>(
                                            context)
                                        .add(JoinEventSubmitName(
                                            joinStateEmailInviteCodeStatus:
                                            widget.joinStateEmailInviteCodeStatus!
                                                .updateWith(
                                                fName: _firstNameController.text.trim(),
                                                lName: _lastNameController.text.trim()
                                            )
                                    ));
                                  } else
                                    BlocProvider.of<JoinScreenBloc>(context)
                                        .add(NavigateToCreatePasswordPage(
                                            firstname: _firstNameController
                                                .text
                                                .trim(),
                                            lastname: _lastNameController
                                                .text
                                                .trim(),
                                            joinStateEmailInviteCodeStatus:
                                            widget.joinStateEmailInviteCodeStatus!
                                                .updateWith(
                                                fName: _firstNameController.text.trim(),
                                                lName: _lastNameController.text.trim()
                                            )
                                    ));
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
    return (_firstNameController.text.trim().length > 0 &&
            _lastNameController.text.trim().length > 0)
        ? true
        : false;
  }
}
