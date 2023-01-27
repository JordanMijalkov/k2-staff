import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/models/k2_staff_profile.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';

class HomeGreetingCard extends StatelessWidget {
  const HomeGreetingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    K2StaffProfile k2staffProfile = context.read<AuthenticationCubit>().state.staffProfile!;

    final bool isMorning = TimeOfDay.now().period == DayPeriod.am;
    return Text(
      "Good ${isMorning ? 'Morning' : 'Afternoon'}, ${k2staffProfile.nickName ?? k2staffProfile.firstName}",
      style: Theme.of(context).textTheme.headline4,
    );
  }
}