import 'package:flutter/material.dart';

class LoginScaffold extends StatelessWidget {
  const LoginScaffold({required this.body, Key? key}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/logo.png"),
                ],
              ),
            ),
          ),
          body: Center(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // <-- notice 'min' here. Important
                      children: [
                Flexible(
                  child: body,
                )
              ])))),
    );
  }
}
