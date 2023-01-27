import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';

class K2AppBarPhone extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<State<StatefulWidget>> heightKey;
  final K2User user;

  @override
  final Size preferredSize;

  K2AppBarPhone({
    Key? key,
    required this.heightKey,
    required this.user,
  }) : preferredSize = Size.fromHeight(60.0), super(key: key);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1.0,
      key: heightKey,
      // backgroundColor: Theme.of(context).secondaryHeaderColor,
      title: Center(child:Text("Cornelius")), //, style: Theme.of(context).textTheme.headline6)),
      actions: <Widget>[
        Container(
            padding: EdgeInsets.only(right: 5.0),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

        SizedBox(
          width: 12.0,
        ),
        IconButton(
          icon: new Icon(Icons.more_vert),
          color: Colors.white,
          onPressed: () {
            _showCustomDialog(context);
          },
        ),
      ],
    ))
      ],

      );
  }


  _showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return
        Theme(
          data: Theme.of(context).copyWith(dialogBackgroundColor: Theme.of(context).dialogBackgroundColor),
                  child: Stack(children: <Widget>[
            Positioned(
                child: Placeholder(),
                //SettingsMenu(user: user, homeBloc: BlocProvider.of<HomeNavBloc>(context),

                //),
                right: 0.0,
                top: _getHeight())
          ]),
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
     // barrierColor: K2Colors.barrierColor,
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
