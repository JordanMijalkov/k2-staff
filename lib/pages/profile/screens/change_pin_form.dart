import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_flutter_core/services/message_service.dart';
import 'package:k2_flutter_core/widgets/textbox_with_header.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/profile/bloc/profile_screen/profile_screen_cubit.dart';
import 'package:pedantic/pedantic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ChangePinForm extends StatefulWidget {
  @override
  _ChangePinFormState createState() => _ChangePinFormState();

  final MessageService messageService = app<MessageService>();
}

class _ChangePinFormState extends State<ChangePinForm> {
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
    
    return Column(
      children: [
        Container(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text("Change PIN",
                      style: Theme.of(context).textTheme.headline1),
                ),
                Card(
                  margin: const EdgeInsets.all(0.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  elevation: 4,
                  child: BlocConsumer<ProfileScreenCubit, ProfileScreenState>(
      listener: (context, state) {
        if (state.passwordChangeStatus == RequestStatus.failure) {
          widget.messageService.show('Failed to change PIN....');
        }
        else if (state.passwordChangeStatus == RequestStatus.success) {
          widget.messageService.show('Changed PIN!');
          Navigator.of(context).pop();
        }
        },
      builder: (context, state) {
        if (state.passwordChangeStatus == RequestStatus.pending)
                    return  const CircularProgressIndicator();
                else return  _form();
      })
                )
              ],
            ),
          ),
        )
      ],
    );
    
  }

  Widget _form() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                                  padding:
                                      const EdgeInsets.only(bottom: 4.0, top: 16.0),
                                  child: 
                  TextBoxWithHeader(
                      labelText: "PIN",
                      hintText: "****",
                      maxLength: 4,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                      ])
                              ),



                                  // Text("PIN",
                                  //     style: Theme.of(context)
                                  //         .textTheme
                                  //         .bodyText1)),
                              // PinCodeTextField(
                              //   controller: controller,
                              //   appContext: context,
                              //   backgroundColor: Colors.transparent,
                              //   length: 4,
                              //   obscuringCharacter: '*',
                              //   obscureText: true,
                              //   animationType: AnimationType.fade,
                              //   textStyle: Theme.of(context).textTheme.bodyText1,
                              //   animationDuration: Duration(milliseconds: 300),
                              //   textInputAction: TextInputAction.next,
                              //   pinTheme: PinTheme(
                              //     shape: PinCodeFieldShape.box,
                              //     borderRadius: BorderRadius.circular(5),
                              //     activeColor:
                              //         Theme.of(context).colorScheme.onSurface,
                              //     inactiveColor:
                              //         Theme.of(context).colorScheme.onSurface,
                              //     fieldHeight: 45,
                              //     fieldWidth: 40,
                              //     activeFillColor: Colors.transparent,
                              //   ),
                              //   onChanged: (pin) {
                              //     setState(() {
                              //       if (pin.trim().length == 4) {
                              //         this._isCodeValid = true;
                              //         this._pin = pin;
                              //       } else
                              //         this._isCodeValid = false;
                              //     });
                              //   },
                              // ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 4.0, top: 16.0),
                                  child: TextBoxWithHeader(
                        labelText: "Confirm PIN",
                        hintText: "****",
                        maxLength: 4,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                        ])),
                                  
                                  
                              //     Text("Confirm PIN",
                              //         style: Theme.of(context)
                              //             .textTheme
                              //             .bodyText1)),
                              // PinCodeTextField(
                              //   appContext: context,
                              //   length: 4,
                              //   backgroundColor: Colors.transparent,
                              //   obscuringCharacter: '*',
                              //   obscureText: true,
                              //   animationType: AnimationType.fade,
                              //   textStyle:
                              //       Theme.of(context).textTheme.bodyText1,
                              //   animationDuration: Duration(milliseconds: 300),
                              //   textInputAction: TextInputAction.next,
                              //   pinTheme: PinTheme(
                              //     shape: PinCodeFieldShape.box,
                              //     borderRadius: BorderRadius.circular(5),
                              //     activeColor:
                              //         Theme.of(context).colorScheme.onSurface,
                              //     inactiveColor:
                              //         Theme.of(context).colorScheme.onSurface,
                              //     fieldHeight: 45,
                              //     fieldWidth: 40,
                              //     activeFillColor: Colors.transparent,
                              //   ),
                              //   onChanged: (pin) {
                              //     setState(() {
                              //       this._confirmPin = pin;
                              //     });
                              //   },
                              // ),

                              (!_passwordsMatch 
                                && _passwordController.text.length == 4
                                && _confirmPasswordController.text.length == 4)
                                  ? Padding(padding: const EdgeInsets.only(bottom: 28.0),
                                      child: const Text("PINs do not match",
                                        style: const TextStyle(color: Colors.redAccent),
                                      ))
                                  : Container(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            child: const Text("Cancel",),
                            onPressed: () {
                              QR.back();
                              // setState(() {
                              //   Navigator.of(context).pop();
                              // });
                            },
                          ),
                          TextButton(
                            child: const Text("Save",),
                            onPressed: _saveAvailable()
                              ? () => _savePressed()
                              : null,
                          ),
                        ],
                      )),
                ])));
  }

  bool _saveAvailable() {
    return (_passwordsMatch && _passwordController.text.length == 4 && _confirmPasswordController.text.length == 4);
  }

  void _savePressed() async {
    unawaited(context.read<ProfileScreenCubit>()
      .updatePIN(context.read<AuthenticationCubit>().state.staffProfile!.id, _passwordController.text));
  }
}
