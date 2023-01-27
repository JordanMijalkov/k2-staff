import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_staff/bloc/application/application_cubit.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';
import 'package:k2_staff/pages/login/bloc/change_password/bloc.dart';
import 'package:k2_staff/pages/login/bloc/forgot_password/bloc.dart';
import 'package:k2_staff/pages/login/bloc/join_request_bloc/bloc.dart';
import 'package:k2_staff/pages/login/bloc/join_screen/bloc.dart';
import 'bloc/join_request_bloc/join_request_bloc.dart';
import 'components/left_login_column.dart';
import 'components/right_login_column.dart';

class LoginPageTablet extends StatefulWidget {
  final ValueChanged<bool>? isSignedIn;
//  static const String route = 'login';
  LoginPageTablet({this.isSignedIn});

  @override
  State<StatefulWidget> createState() {
    return LoginPageTabletState();
  }
}

class LoginPageTabletState extends State<LoginPageTablet>
    with SingleTickerProviderStateMixin<LoginPageTablet> {
  AnimationController? _animationController;
  Animation? _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController!);
  }

  @override
  dispose() {
    _animationController!.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (MediaQuery.of(context).size.width > 600)
    //   SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    // else
    //   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
              create: (BuildContext context) => 
              LoginBloc(
                  authBloc: BlocProvider.of<AuthenticationCubit>(context))),
                 // applicationCubit: BlocProvider.of<ApplicationCubit>(context))),
          BlocProvider<ForgotPasswordBloc>(
              create: (BuildContext context) => ForgotPasswordBloc()),
          BlocProvider<ChangePasswordBloc>(
              create: (BuildContext context) => ChangePasswordBloc()),
          BlocProvider<JoinRequestBloc>(
              create: (BuildContext context) => JoinRequestBloc()),
          BlocProvider<JoinScreenBloc>(
              create: (BuildContext context) => JoinScreenBloc()),
        ],
        child: 
        BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (BuildContext context, AuthenticationState state) {
        if (state.status == AuthenticationStatus.awaiting) {
          widget.isSignedIn!(true);
          return loadingPage(context);
        }
        else
        return Scaffold(body: Center(child:
            BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          return Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: LeftLoginColumn(
                    animationController: _animationController,
                    animation: _animation,
                  )),
              if (MediaQuery.of(context).size.width > 1000)
                Expanded(
                    flex: 1,
                    child: RightLoginColumn(
                      animationController: _animationController,
                      animation: _animation,
                    )),
            ],
          );
        })));

          })
        );
  }

  Widget loadingPage(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Stack(
          children: <Widget>[
            //background(),
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                mainImage(Text("Loading your profile...")),
                progressIndicator(context, Text("Let's find all your centers and permissions!")),
              ],
            )
          ],
        ),
      ),
    );

  }

  Widget mainImage(Text title) {
    return Expanded(
      flex: 2,
      child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new CircleAvatar(
                backgroundColor: Colors.transparent,
                child: new Container(
                    child: Image.asset("assets/images/splash.png"),
                ),
                radius: 150.0,
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 10.0),
              ),
              title
            ],
          )),
    );
  }

  // Widget background() {
  //   return Container(
  //      decoration: this.imageBackground!=null ? new BoxDecoration(
  //       image: new DecorationImage(
  //         image: this.imageBackground,
  //         fit: BoxFit.cover,
  //       ),
  //     ): BoxDecoration(color: this.backgroundColor),);
  // }

  Widget progressIndicator(BuildContext context, Text loadingText) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          loadingText
        ],
      ),
    );
  }

}
