import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';

class LoginFormSSOWebView extends StatelessWidget {
  final Animation? animation;
  final String? redirectUrl;
  final String? ssoUrl;
  const LoginFormSSOWebView({Key? key, this.animation, this.ssoUrl, this.redirectUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Completer<WebViewController> _controller = Completer<WebViewController>();
    WebViewController webViewController;
    return BlocBuilder<LoginBloc, LoginState>(builder: (
      BuildContext context,
      LoginState loginState,
    ) {
      return WebView(
        initialUrl: ssoUrl,
        onWebViewCreated: (c) {
          _controller.complete(c);
          webViewController = c;
          var cookieManager = CookieManager();
          cookieManager.clearCookies();
          webViewController.clearCache();
        },
        onPageFinished: (String page) async {
          if (page.startsWith(redirectUrl!)) {
            Uri uri = Uri.parse(page);
            String? code = uri.queryParameters["code"];
            if (code != null) {
              BlocProvider.of<LoginBloc>(context)
                  .add(LoginEventSSOLoginCodeReceived(code: code));
            } else {
              BlocProvider.of<LoginBloc>(context).add(
                  LoginEventSSOLoginFailed(error: 'Unable to Login via SSO!'));
            }
          }
        },
        javascriptMode: JavascriptMode.unrestricted,
      );
    });
  }
}
