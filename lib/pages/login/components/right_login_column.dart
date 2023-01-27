import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';

class RightLoginColumn extends StatefulWidget {
  final AnimationController? animationController;
  final Animation? animation;

  Future<void> playAnimation() async {
    animationController!.reset();
    animationController!.forward();
  }

  const RightLoginColumn(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RightLoginColumnState();
  }
}

class _RightLoginColumnState extends State<RightLoginColumn> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.playAnimation(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return BlocBuilder<LoginBloc,LoginState>(
          builder: (context, state) { 
        switch (state.runtimeType) {
          case LoginStateForgotPassword:
            {
              return Center(
                  child: Image.asset(
                'assets/images/forgotpw.png',
              ));
            }
          case LoginStateSSOLogin:
          case LoginStateSSOWebViewLogin:
            {
              return Center(
                  child: Image.asset(
                'assets/images/login.png',
              ));
            }
          case LoginStateFailure:
            {
              // TODO
              return Center(
                  child: Image.asset(
                'assets/images/login.png',
              ));
            }
          case LoginStateNewPasswordRequired:
            {
              // TODO
              return Center(
                  child: Image.asset(
                'assets/images/login.png',
              ));
            }
          case LoginStatePasswordChangeRequested:
            {
              // TODO
              return Center(
                  child: Image.asset(
                'assets/images/login.png',
              ));
            }
          case LoginStateSwitchUserRequested:
            {
              // TODO
              return Center(
                  child: Image.asset(
                'assets/images/login.png',
              ));
            }
          default:
            {
              // This would be LoginStateDefault
              return Center(
                  child: Image.asset(
                'assets/images/login.png',
              ));
            }
        }

      });
      },
    );
  }
}
