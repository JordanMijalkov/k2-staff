import 'package:flutter/material.dart';
import 'package:k2_staff/bloc/application/application_cubit.dart';
import 'package:k2_staff/bloc/kisi/kisi_cubit.dart';
import 'package:k2_staff/core/widgets/scaffold/login_scaffold.dart';


import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisclosureScreen extends StatelessWidget {
  DisclosureScreen({Key? key}) : super(key: key);
  // final CoreApiService coreApiService = app<K2CoreApiClient>();

  @override
  Widget build(BuildContext context) {
    double width = 500;
    return BlocProvider(
      create: (context) => KisiCubit(),
      child: Builder(
        builder: (context) {
          return LoginScaffold(
              body: Container(
                  padding: EdgeInsets.symmetric(vertical: 34),
                  width: 500,
                  //  height: 390,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Kangarootime Would like Permission to Access your Location',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Container(
                          width: width,
                          child: Padding(
                              padding: EdgeInsets.only(top: 24),
                              child: Text(
                                "Kangarootime collects location data to enable Door Unlock functionality, even when the app is closed or not in use.\n\nPress Accept to allow use of your Location.",
                                style: Theme.of(context).textTheme.bodyText1,
                              )),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () => null, child: Text("Deny")),
                              TextButton(
                                  onPressed: () async {
                                    await context.read<KisiCubit>().initLocks();
                                    context
                                        .read<ApplicationCubit>()
                                        .seenDisclosureScreen();
                                  },
                                  child: Text("Accept"))
                            ],
                          ),
                        )
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 15.0),
                        //   child: SizedBox(
                        //       height: 40.0,
                        //       width: 375,
                        //       child: TextButton(
                        //           child: Text("No thank you, take me to my Center!"),
                        //           onPressed: () => QR.navigator.replaceAll('/home')
                        //           // QR.to('/settings')
                        //           // context.read<SelectPersonBloc>()
                        //           //     .add(SelectPersonEventCancel()),
                        //           )),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 25.0),
                        //   child: SizedBox(
                        //       height: 40.0,
                        //       width: width,
                        //       child: ElevatedButton(
                        //         child: Text("Reset..."),
                        //         onPressed: () async {
                        //           String centerId = context
                        //               .read<ApplicationCubit>()
                        //               .state
                        //               .center!
                        //               .id!;
                        //           await coreApiService.resetCenterState(centerId);
                        //           await coreApiService.setCenterSession(
                        //               centerId,
                        //               context
                        //                   .read<ApplicationCubit>()
                        //                   .getSessionDay()
                        //                   .toString());
                        //           context.read<ApplicationCubit>().flagCenterReset();
                        //           QR.navigator.replaceAll('/home');
                        //         },
                        //       )),
                        // ),
                      ],
                    ),
                  )));
        }
      ),
    );
  }
}
