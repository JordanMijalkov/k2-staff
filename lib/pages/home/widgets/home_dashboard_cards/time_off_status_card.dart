import 'package:flutter/material.dart';
import 'package:k2_staff/core/colors.dart';

class TimeOffStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimeOffStatus();
  }
}

class TimeOffStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: K2Colors.secondaryOrange,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("You are waiting for Approval", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: K2Colors.white),),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Text("07/12/2020", style: Theme.of(context).textTheme.headline2!.copyWith(color: K2Colors.white),),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}