import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_flutter_core/services/message_service.dart';
import 'package:k2_flutter_core/widgets/textbox_with_header.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/profile/pin/cubit/pin_cubit.dart';
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
    return SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              
                BlocConsumer<PinCubit, PinState>(
                    listener: (context, state) {
                  if (state.pinRequestStatus == PinRequestStatus.failure) {
                    widget.messageService.show('Failed to change PIN...');
                  } else if (state.pinRequestStatus ==
                      PinRequestStatus.success) {
                    widget.messageService.show('Changed PIN!');
                    Navigator.of(context).pop();
                  }
                }, builder: (context, state) {
                  if (state.pinRequestStatus == PinRequestStatus.pending) {
                    return const CircularProgressIndicator();
                  } else {
                    return _form();
                  }
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _form() {
    return 
          Column(
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
              (!_passwordsMatch &&
                      _passwordController.text.length == 4 &&
                      _confirmPasswordController.text.length ==
                          4)
                  ? Padding(
                      padding:
                          const EdgeInsets.only(bottom: 28.0),
                      child: const Text(
                        "PINs do not match",
                        style: const TextStyle(
                            color: Colors.redAccent),
                      ))
                  : Container(),
            
SizedBox(
      child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity,
          40), // double.infinity is the width and 40 is the height
    ),
    child: Text("Save"),
            onPressed:
                _saveAvailable() ? () => _savePressed() : null,
      )),

          Padding(
            padding: const EdgeInsets.only(top:12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text(
                    "Cancel",
                  ),
                  onPressed: () {
                    setState(() {
                      QR.to('/home');
                    });
                  },
                ),
              ],
            ),
          ),
        ]);
  }

  bool _saveAvailable() {
    return (_passwordsMatch &&
        _passwordController.text.length == 4 &&
        _confirmPasswordController.text.length == 4);
  }

  void _savePressed() {
    unawaited(
        context.read<PinCubit>().updatePIN(context.read<AuthenticationCubit>().state.staffProfile!.id,
          _passwordController.text));
  }
}
