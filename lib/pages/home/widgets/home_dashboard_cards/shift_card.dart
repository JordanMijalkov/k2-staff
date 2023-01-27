import 'package:flutter/material.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';

class ShiftCard extends StatelessWidget {
  final K2TimeEntry? openTimeEntry;
  final VoidCallback? onTap;

  const ShiftCard({Key? key, this.openTimeEntry, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
    // return BlocBuilder<CurrentCenterBloc, CurrentCenterState>(
    //     builder: (context, state) {
    //   if (state is CurrentCenterState) {
    //     return InkWell(
    //       child: ClockStatusCard(
    //         openTimeEntry: openTimeEntry,
    //       ),
    //       onTap: onTap,
    //     );
    //   } else {
    //     return Text("No Center Selected!"); // TODO
    //   }
    // });
  }
}