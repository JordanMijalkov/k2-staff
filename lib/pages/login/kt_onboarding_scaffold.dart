import 'package:flutter/material.dart';

class KtOnboardingScaffold extends StatelessWidget {
  final Widget? child;

  KtOnboardingScaffold({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double offsetPercentage = .925;
    double width = 0;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
      width = constraint.maxWidth * offsetPercentage;
      double offsetwidth = constraint.maxWidth - width;
      return Container(
          child: Padding(
        padding: EdgeInsets.only(
            top: offsetwidth, left: offsetwidth, right: offsetwidth),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 51,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fill)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text("Welcome To",
                    style: Theme.of(context).textTheme.headline1),
              ),
              Text(
                "Kangarootime",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFamily: "ProximaSoft",
                    fontStyle: FontStyle.normal,
                    fontSize: 32.0,
                    color: Theme.of(context).textTheme.headline1!.color),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Card(
                      margin: EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                      ),
                      elevation: 4,
                      child: this.child,
                    )),
              )
            ]),
      ));
    });
  }
}
