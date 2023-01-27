import 'package:flutter/material.dart';
import 'package:k2_flutter_api/models/enums/k2_clock_out_type.dart';
import 'package:websafe_svg/websafe_svg.dart';

  const success = const Color(0xff42b964);
  const warning = const Color(0xfff7b500);
  const danger = const Color(0xffb81111);

class ClockIcon extends StatelessWidget {
  final K2ClockOutType? ccType;
  final Color? iconColor;
  ClockIcon({Key? key, this.ccType, this.iconColor}) : super(key: key);

  Widget _buildIcon() {
    Color color = success;
    String icon = 'clock.svg';
    switch (this.ccType) {
      case K2ClockOutType.ClockOut:
        color = danger;
        icon = 'clock.svg';
        break;
      case K2ClockOutType.StartBreak:
        color = warning;
        icon = 'pause-circle.svg';
        break;
      default:
        break;
    }
    return WebsafeSvg.asset(
      'assets/svgs/$icon',
      color: iconColor ?? color,
      fit: BoxFit.contain,
      height: 40,
      width: 40,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildIcon();
  }
}
