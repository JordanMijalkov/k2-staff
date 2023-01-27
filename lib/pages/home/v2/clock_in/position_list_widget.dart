import 'package:flutter/material.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_flutter_core/widgets/column_builder.dart';
import 'package:k2_staff/pages/home/v2/clock_in/clock_in_button.dart';


class PositionListWidget extends StatelessWidget {
  const PositionListWidget(
      {required this.width, required this.positions, Key? key})
      : super(key: key);
  final List<K2Position> positions;
  final double width;

  @override
  Widget build(BuildContext context) {
    int rows = positions.length ~/ 2;
print(width);
    return width < 450 
    ? ColumnBuilder(
      itemCount: positions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom:12.0),
          child: ClockInButton(
                  position: positions[index], 
                  width: width,
                  showConfirmationDialog: true
                ),
        );
      } 
      )
    : Column(children: [
      positions.length > 1
          ? ColumnBuilder(
              itemCount: rows,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClockInButton(
                      position: positions[index], 
                      width: (width ~/ 2) - 6,
                      showConfirmationDialog: true,
                    ),
                    SizedBox(width: 12,),
                    ClockInButton(
                      position: positions[index+1],
                      width: (width ~/ 2) - 6,
                      showConfirmationDialog: true
                    )
                  ],
                );
              },
            )
          : ClockInButton(
              position: positions[0],
              width: width % 2,
              showConfirmationDialog: false
            ),
      positions.length.remainder(2) == 1
          ? Padding(
            padding: const EdgeInsets.only(top:16.0),
            child: ClockInButton(
                position: positions[positions.length-1], 
                width: width,
                showConfirmationDialog: true
              ),
          )
          : Container()
    ]);
  }
}
