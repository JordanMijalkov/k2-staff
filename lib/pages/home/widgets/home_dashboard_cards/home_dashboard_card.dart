import 'package:flutter/material.dart';

class HomeDashboardCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;

  const HomeDashboardCard(
      {Key? key, this.child, this.padding = const EdgeInsets.only(top: 8.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}