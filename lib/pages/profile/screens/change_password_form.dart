import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_core/components/form_validators.dart';
import 'package:k2_flutter_core/k2_flutter_core_widgets.dart';
import 'package:k2_flutter_core/services/message_service.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
import 'package:k2_staff/pages/profile/bloc/profile_screen/profile_screen_cubit.dart';
import 'package:pedantic/pedantic.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'profile_menu_phone.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileScreenCubit>(
          create: (BuildContext context) => ProfileScreenCubit(),
          child:KTScaffold(
        title: 'Password',
        body:ChangePasswordForm()
          )
      
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final MessageService messageService = app<MessageService>();

  FocusNode _focusNodePassword = new FocusNode();
  FocusNode _focusNodeOldPassword = new FocusNode();
  FocusNode _focusNodeConfirmPassword = new FocusNode();

  bool _passwordsMatch = true;
  bool _obscureText0 = true;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  void initState() {
    // _oldPasswordController.text = "Password1234!";
    // _passwordController.text = "Password123!";
    // _confirmPasswordController.text = "Password123!";
    // _changePasswordBloc = ChangePasswordBloc();
    // _changePasswordBloc.add(ChangePasswordEventRequested());
    super.initState();

    _passwordController.addListener(() {
      if (_passwordController.text.length > 3 &&
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
      if (_passwordController.text.length > 3 &&
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
    return BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 500,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text("Change Password",
                                style: Theme.of(context).textTheme.headline1),
                          ),
                          BlocConsumer<ProfileScreenCubit,
                              ProfileScreenState>(listener: (context, state) {
                            if (state.passwordChangeStatus ==
                                RequestStatus.failure) {
                              messageService
                                  .show('Failed to change Password....');
                            } else if (state.passwordChangeStatus ==
                                RequestStatus.success) {
                              messageService.show('Changed Password!');
                              Navigator.of(context).pop();
                            }
                          }, builder: (context, state) {
                            if (state.passwordChangeStatus ==
                                RequestStatus.pending)
                              return const CircularProgressIndicator();
                            else
                              return _form();
                          })
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );

//   double offsetPercentage = .925;
//     double width = 0;
//  return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraint) {
//       width = constraint.maxWidth * offsetPercentage;
//       double offsetwidth = constraint.maxWidth - width;
//       return Container(
//           child: Padding(
//             padding: const EdgeInsets.only(
//                 top: offsetwidth, left: offsetwidth, right: offsetwidth),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   // Container(
//                   //   width: 51,
//                   //   height: 54,
//                   //   alignment: Alignment.center,
//                   //   decoration: BoxDecoration(
//                   //       image: DecorationImage(
//                   //           image: AssetImage('assets/images/logo.png'),
//                   //           fit: BoxFit.fill)),
//                   // ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
//                     child: Text("Change Password",
//                         style: Theme.of(context).textTheme.headline1),
//                   ),
//                   Expanded(
//                     child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 16.0),
//                         child: Card(
//                           margin: EdgeInsets.all(0.0),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                           ),
//                           elevation: 4,
//                           child: _form(),
//                         )),
//                   )
//                 ]),
//           ));
//     });
  }

  Widget _form() {
    // ProfileScreenStatus stat =
    //     context.read<ProfileScreenCubit>().state.screenStatus;

    // print(stat);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextBoxWithHeader(
                  labelText: "Old Password",
                  hintText: "*****",
                  obscureText: _obscureText0,
                  focusNode: _focusNodeOldPassword,
                  controller: _oldPasswordController,
                  bottomPadding: 16,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(
                        context, _focusNodeOldPassword, _focusNodePassword);
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
                  validator: FormValidators.passwordValidator,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp("[\\t]"))
                  ]),
            ),
            TextBoxWithHeader(
                labelText: "New Password",
                hintText: "*****",
                obscureText: _obscureText1,
                focusNode: _focusNodePassword,
                controller: _passwordController,
                bottomPadding: 16,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(
                      context, _focusNodePassword, _focusNodeConfirmPassword);
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
                  child: Icon(
                      _obscureText1 ? Icons.visibility : Icons.visibility_off),
                ),
                validator: FormValidators.passwordValidator,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp("[\\t]"))
                ]),
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
                  child: Icon(
                      _obscureText2 ? Icons.visibility : Icons.visibility_off),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp("[\\t]"))
                ]),
            !_passwordsMatch
                ? const Text(
                    "Passwords do not match",
                    style: TextStyle(color: Colors.redAccent),
                  )
                : Container(),
            Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text(
                        "Cancel",
                      ),
                      onPressed: () {
                        QR.back();
                        // setState(() {
                        //   Navigator.of(context).pop();
                        // });
                      },
                    ),
                    TextButton(
                      child: Text(
                        "Save",
                      ),
                      onPressed: _saveAvailable() ? () => _savePressed() : null,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  bool _saveAvailable() {
    return (_passwordsMatch &&
        _oldPasswordController.text.length > 4 &&
        _confirmPasswordController.text.length > 4);
  }

  void _savePressed() async {
    unawaited(context
        .read<ProfileScreenCubit>()
        .updatePassword(_oldPasswordController.text, _passwordController.text));
  }
}
