import 'package:flutter/material.dart';

class JoinOnboardingPage extends StatefulWidget {
  @override
  State createState() => new JoinOnboardingPageState();
}

class JoinOnboardingPageState extends State<JoinOnboardingPage> {
  final _controller = new PageController();

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  final List<Widget> _pages = <Widget>[
    Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        child: Container(
          width: 51,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/logo.png'),
          )),
        ),
      ),
    ),
    Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Container(
          child: Container(
            width: 51,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
            )),
          ),
        )),
    Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Container(
        child: Container(
          width: 51,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/logo.png'),
          )),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double offsetPercentage = .925;
    double verticalOffset = .88;
    double width;
    double height;

    return Scaffold(
        backgroundColor: Color(0xff513c5e),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraint) {
          width = constraint.maxWidth * offsetPercentage;
          height = constraint.maxHeight * verticalOffset;

          double offsetwidth = constraint.maxWidth - width;
          double offsetheight = constraint.maxHeight - height;
          return Stack(
            children: <Widget>[
              Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: offsetwidth, vertical: offsetheight),
                    child: PageView.builder(
                      physics: new AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      itemBuilder: (BuildContext context, int index) {
                        return _pages[index % _pages.length];
                      },
                    )),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // DotsIndicator(
                      //   controller: _controller,
                      //   itemCount: _pages.length,
                      //   onPageSelected: (int page) {
                      //     _controller.animateToPage(
                      //       page,
                      //       duration: _kDuration,
                      //       curve: _kCurve,
                      //     );
                      //   },
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text("Skip",
                            style:
                                TextStyle(color: Colors.white)), //flat button
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }));
  }
}
