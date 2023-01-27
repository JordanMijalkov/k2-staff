import 'package:flutter/material.dart';
import 'package:k2_flutter_api/models/k2_user.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'app_bar_phone.dart';
import 'app_bar_tablet.dart';

class K2AppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<State<StatefulWidget>> heightKey;
  final K2User user;

  @override
  final Size preferredSize;

  K2AppBar({
    Key? key,
    required this.heightKey,
    required this.user,
  })  : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => K2AppBarPhone(key: key, heightKey: heightKey, user: user),
      tablet: (BuildContext context) => K2AppBarTablet(key: key, heightKey: heightKey, user: user),
    );
  }
}
