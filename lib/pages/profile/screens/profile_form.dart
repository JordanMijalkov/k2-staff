import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_flutter_core/k2_flutter_core_services.dart';
import 'package:k2_flutter_core/k2_flutter_core_widgets.dart';
import 'package:k2_staff/bloc/application/application_cubit.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/core/widgets/date_field_picker.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
import 'package:k2_staff/pages/profile/bloc/profile_screen/profile_screen_cubit.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'profile_menu_phone.dart';

typedef ProfileFormSubmit<T> = void Function(T value);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileScreenCubit>(
          create: (BuildContext context) => ProfileScreenCubit(),
          child:ProfileForm()
          
      
    );
  }
}

class ProfileForm extends StatefulWidget {
  final ProfileFormSubmit<K2StaffProfile>? onSubmit;
  //final K2StaffProfile k2staffProfile;

  ProfileForm({
    this.onSubmit,
  });

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  // static final _UsNumberTextInputFormatter _birthDate =
  //     new _UsNumberTextInputFormatter();

  final _formKey = GlobalKey<FormState>();
  late final K2StaffProfile k2staffProfile;
  final MessageService messageService = app<MessageService>();

  String? phoneNumber;
  String? phoneIsoCode;

  @override
  void initState() {
    super.initState();
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  onValidPhoneNumber(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      //  confirmedNumber = internationalizedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    k2staffProfile = context.read<AuthenticationCubit>().state.staffProfile!;
    return KTScaffold(
        title: 'Profile',
        body: ScreenTypeLayout.builder(
          mobile: (BuildContext context) => CustomScrollView(
            slivers: <Widget>[SliverToBoxAdapter(child: _mainForm(context))],
          ),
          tablet: (BuildContext context) => _mainForm(context),
        ));
  }

  _mainForm(context) {
    return BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
      builder: (context, state) {
                          return BlocConsumer<ProfileScreenCubit,
                              ProfileScreenState>(listener: (context, state) {
                            if (state.profileSaveStatus ==
                                RequestStatus.failure) {
                              messageService
                                  .show('Failed to change Profile....');
                            } else if (state.profileSaveStatus ==
                                RequestStatus.success) {
                              messageService.show('Changed Profile!');
                              Navigator.of(context).pop();
                            }
                          }, builder: (context, state) {
                            if (state.profileSaveStatus ==
                                RequestStatus.pending) {
                              return const CircularProgressIndicator();
                                }
                            else
                              return 
                                  
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Profile Information",
                          style: Theme.of(context).textTheme.headline5),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 260,
                                  child: TextBoxWithHeader(
                                    onSaved: (value) {
                                      k2staffProfile.nickName = value;
                                    },
                                    bottomPadding: 8,
                                    labelText: "Preferred Name",
                                    hintText: 'N/A',
                                    initialValue: k2staffProfile.nickName,
                                  ),
                                ),
                                Container(
                                    width: 230,
                                    child: DateFieldPicker(
                                      onChanged: (value) {
                                        k2staffProfile.dob =
                                            value!.toIso8601String();
                                      },
                                      // validator: (value) {
                                      //   if (value!.isEmpty) {
                                      //     return 'This field is required';
                                      //   }
                                      //   return null;
                                      // },
                                      bottomPadding: 8,
                                      labelText: "Date of Birth",
                                      initialValue: DateTime.parse(
                                          k2staffProfile.dob ?? '01-01-2000'),
                                      // initialValue: Jiffy(
                                      //         k2staffProfile.dob ?? '01-01-2000', 'dd-MM-yyyy')
                                      //     .dateTime,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 240,
                                  child: TextBoxWithHeader(
                                    onSaved: (value) {
                                      k2staffProfile.firstName = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    bottomPadding: 8,
                                    labelText: "First Name",
                                    hintText: 'N/A',
                                    initialValue: k2staffProfile.firstName,
                                  ),
                                ),
                                Container(
                                  width: 240,
                                  child: TextBoxWithHeader(
                                    onSaved: (value) {
                                      k2staffProfile.lastName = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    bottomPadding: 8,
                                    labelText: "Last Name",
                                    hintText: 'N/A',
                                    initialValue: k2staffProfile.lastName,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 300,
                                  child: TextBoxWithHeader(
                                    onSaved: (value) {
                                      k2staffProfile.address?.address1 = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    bottomPadding: 8,
                                    labelText: "Street Address",
                                    hintText: 'N/A',
                                    initialValue:
                                        k2staffProfile.address?.address1,
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: TextBoxWithHeader(
                                    onSaved: (value) {
                                      k2staffProfile.address?.address2 = value;
                                    },
                                    bottomPadding: 8,
                                    labelText: "Apt. Suite",
                                    hintText: 'N/A',
                                    initialValue: "",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 175,
                                  child: TextBoxWithHeader(
                                    onSaved: (value) {
                                      k2staffProfile.address?.city = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    bottomPadding: 8,
                                    labelText: "City",
                                    hintText: 'N/A',
                                    initialValue: k2staffProfile.address?.city,
                                  ),
                                ),
                                Container(
                                  width: 180,
                                  child: TextBoxWithHeader(
                                    onSaved: (value) {
                                      k2staffProfile.address?.state = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    bottomPadding: 8,
                                    labelText: "State",
                                    hintText: 'N/A',
                                    initialValue: k2staffProfile.address?.state,
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  child: TextBoxWithHeader(
                                    onSaved: (value) {
                                      k2staffProfile.address?.postalCode =
                                          value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    bottomPadding: 8,
                                    labelText: "ZIP Code",
                                    hintText: 'N/A',
                                    initialValue:
                                        k2staffProfile.address?.postalCode,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // InternationalPhoneInput(
                      //     onPhoneNumberChange: onPhoneNumberChange,
                      //     initialPhoneNumber: k2staffProfile.phoneNumber ?? '',
                      //     initialSelection: phoneIsoCode ?? 'US',
                      //     enabledCountries: ['+233', '+1']),
                      Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      QR.back();
                                      // setState(() {
                                      //   // BlocProvider.of<PhoneScreenBloc>(context)
                                      //   //     .add(
                                      //   //         Navigate(page: ProfileMenuPhone()));
                                      // });
                                    }),
                                SizedBox(width: 16),
                                ElevatedButton(
                                  child: Text('Save'),
                                  onPressed: () {
                                    if (null != _formKey.currentState &&
                                        _formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      k2staffProfile.phoneNumber =
                                          phoneNumber ??
                                              k2staffProfile.phoneNumber;
                                      //this.widget.onSubmit!(k2staffProfile);
                                      unawaited(context
                                          .read<ProfileScreenCubit>()
                                          .saveProfile(k2staffProfile));
                                    }
                                  },
                                )
                              ])),
                    ],
                  )),
            ),
          ),
        );
        });
      },
    );
  }
}


class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + '/');
      if (newValue.selection.end >= 2) selectionIndex++;
    }
    if (newTextLength >= 5) {
      newText.write(newValue.text.substring(2, usedSubstringIndex = 4) + '/');
      if (newValue.selection.end >= 4) selectionIndex++;
    }
    if (newTextLength >= 9) {
      newText.write(newValue.text.substring(4, usedSubstringIndex = 8));
      if (newValue.selection.end >= 8) selectionIndex++;
    }
// Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
