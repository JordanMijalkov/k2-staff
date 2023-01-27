import 'package:flutter/material.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_staff/pages/home/v2/cubit/staff_cubit.dart';
import 'package:k2_staff/pages/home/v2/k2_confirmation_dialog.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ClockInButton extends StatelessWidget {
  ClockInButton({ required this.position, required this.width, 
  required this.showConfirmationDialog, Key? key}) : super(key: key);
  final K2Position position;
  final double width;
  final bool showConfirmationDialog;
  final DateFormat timeFormatter = new DateFormat('hh:mm:ss a');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffCubit, StaffState>(
      builder: (context, state) {
        return SizedBox(
          height: 50,
          width: width,
          child: ElevatedButton(
              onPressed: () {
                if (showConfirmationDialog) {
                 showDialog(
                    context: context,
                    builder: (_) => K2ConfirmDialog(
                          title: '',
                          content:
                              "Your're clocking in at ${timeFormatter.format(new DateTime.now().toLocal())} as ${position.title ?? 'Position 1'}",
                          primaryButton: K2PrimaryButton(
                            buttonText: 'Confirm',
                            onPressed: () {
                              context
                                  .read<StaffCubit>()
                                  .clockIn(position);
                              Navigator.pop(context, true);
                            },
                          ),
                          secondaryButton: K2SecondaryButton(
                            buttonText: 'Cancel',
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                        )).then((value) {
                  if (value) {
                    QR.navigator.replaceAll('/clockInSuccess');
                  }
                });
                }
                else {
                  context
                                  .read<StaffCubit>()
                                  .clockIn(position);
                  QR.navigator.replaceAll('/clockInSuccess');
                } 
                ;
              },
              child: Text(
                position.title ?? 'Position 1',
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
              ),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary)),
        );
      },
    );
  }
}
