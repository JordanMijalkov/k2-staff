import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
import 'package:k2_staff/pages/time_off_request/cubit/time_off_request_cubit.dart';
import 'package:k2_staff/pages/time_off_request/time_off_request_created_screen.dart';
import 'package:k2_staff/pages/time_off_request/time_off_request_form.dart';
import 'package:k2_staff/pages/time_off_request/time_off_request_history.dart';
import 'package:k2_staff/pages/time_off_request/time_off_request_review_screen.dart';

class TimeOffRequestScreen extends StatelessWidget {
  const TimeOffRequestScreen({Key? key, required this.fromWhere}) : super(key: key);
  final String fromWhere;
  @override
  Widget build(BuildContext context) {

    
    return BlocProvider(
      create: (context) => TimeOffRequestCubit(),
      child: KTScaffold(
        showLeading: fromWhere == 'menu' ? true : false,
        body: BlocBuilder<TimeOffRequestCubit, TimeOffRequestState>(
          builder: (context, state) {
            switch (state.status) {
              case TimeOffRequestStatus.creating:
                return TimeOffRequestForm();
              case TimeOffRequestStatus.review:
               return TimeOffRequestReviewScreen();
              case TimeOffRequestStatus.submitted:
                return TimeOffRequestCreatedScreen();
              case TimeOffRequestStatus.history:
                return TimeOffRequestHistoryScreen();
            }      
          },
        ),
      ),
    );
  }
}
