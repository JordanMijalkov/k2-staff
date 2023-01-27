import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_core/theme/bloc/theme_cubit.dart';
import 'package:k2_staff/bloc/application/application_cubit.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/bloc/kisi/kisi_cubit.dart';

/// The [GlobalBlocProvider] is built above the root [MaterialApp] to provide
/// every descendant with globally available blocs.
///
/// These blocs will only be created once.
class GlobalBlocProvider extends StatelessWidget {
  GlobalBlocProvider({
    required this.child,
  });

  final Widget child;

  
  @override
  Widget build(BuildContext context) {
    return 
    MultiBlocProvider(
      providers: [
        // theme
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => KisiCubit()),

        // authentication
        BlocProvider<AuthenticationCubit>(
          create: (BuildContext context) => AuthenticationCubit(
  //          themeBloc: context.read<ThemeCubit>(),
          ),
        ),

        // application
        // can't be lazy since initialization starts upon bloc creation
        BlocProvider<ApplicationCubit>(
          lazy: false,
          create: (BuildContext context) => ApplicationCubit(
             context.read<AuthenticationCubit>(),
            // themeBloc: context.read<ThemeCubit>(),
          )
          ..initializeApp(),
        ),
      ],
      child: child,
    );
  }
}
