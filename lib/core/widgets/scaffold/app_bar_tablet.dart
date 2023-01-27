import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'package:k2_flutter_api/k2_staff_profile_container.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/widgets/k2_staff_profile_widget.dart';

class K2AppBarTablet extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<State<StatefulWidget>> heightKey;
  final K2User user;

  @override
  final Size preferredSize;

  K2AppBarTablet({
    Key? key,
    required this.heightKey,
    required this.user,
  })  : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    K2StaffProfile _k2staffProfile =
        context.read<AuthenticationCubit>().state.staffProfile!;

    return AppBar(
      elevation: 1.0,
      key: heightKey,
      actions: <Widget>[
        Container(
            padding: EdgeInsets.only(right: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_k2staffProfile.fullName),
              ],
            )),
        Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _k2staffProfile.avatarWidget()
          ]),
        ),
        SizedBox(
          width: 12.0,
        ),
        // IconButton(
        //   icon: new Icon(Icons.more_vert),
        //   color: Colors.grey,
        //   onPressed: () {
        //     _showCustomDialog(context);
        //   },
        // ),
      ],
    );
  }

  _showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Stack(children: <Widget>[
          Positioned(child: Placeholder(),
              // child: SettingsMenu(
              //   user: user,
              //   homeBloc: BlocProvider.of<HomeNavBloc>(context),
              // ),
              right: 0.0,
              top: _getHeight())
        ]);
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Color.fromARGB(100, 124, 124, 124),
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  _getHeight() {
    if (null != heightKey.currentContext) {
      RenderBox box = heightKey.currentContext!.findRenderObject() as RenderBox;
      var p = box.localToGlobal(Offset.zero);
      return box.size.height + p.dy;
    } else
      return 100.0;
  }
}
