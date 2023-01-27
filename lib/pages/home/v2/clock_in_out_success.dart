import 'package:flutter/material.dart';
import 'package:k2_staff/core/widgets/clock_icon.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ClockInOutSuccessScreen extends StatefulWidget {
  const ClockInOutSuccessScreen({required this.clockingIn, Key? key})
      : super(key: key);
  final bool clockingIn;

  @override
  State<ClockInOutSuccessScreen> createState() =>
      _ClockInOutSuccessScreenState();
}

class _ClockInOutSuccessScreenState extends State<ClockInOutSuccessScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = 353;

    return KTScaffold(
        backgroundColor: Colors.grey[200],
        showIcon: true,
        title: "",
        body: Center(
          child: Wrap(children: [
            Container(
                width: 450,
                // padding: const EdgeInsets.symmetric(vertical: 60.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                        color: Colors
                            .transparent // Theme.of(context).colorScheme.onSurface,
                        ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      ClockIcon(),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        widget.clockingIn ? "Welcome!" : "Enjoy Your Day!",
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: Colors.green),
                      ),
                      SizedBox(
                        height: 48,
                      ),
                      Text(
                          widget.clockingIn
                              ? "You're Clocked In"
                              : "You're Clocked Out",
                          style: Theme.of(context).textTheme.headline3!),
                      SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 48,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SizedBox(
                          width: width,
                          height: 40,
                          child: ElevatedButton(
                            child: Text("Close"),
                            onPressed: () async {
                              QR.navigator.replaceAll('/home');
                            },
                          ),
                        ),
                      ),
                    ])),
          ]),
        ));
  }
}
