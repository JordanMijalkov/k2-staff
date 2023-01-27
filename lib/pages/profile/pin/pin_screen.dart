import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
import 'package:k2_staff/pages/profile/pin/cubit/pin_cubit.dart';
import 'package:k2_staff/pages/profile/pin/pin_form.dart';


class PinScreen extends StatelessWidget {
  const PinScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => PinCubit(),
    child: 
    KTScaffold(title: 'Change Pin', body: ChangePinForm()));
  }
}