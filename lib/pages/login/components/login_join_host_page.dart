import 'package:flutter/material.dart';
import 'package:k2_staff/pages/login/kt_onboarding_scaffold.dart';
import 'login_form_default.dart';

class LoginJoinHostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KtOnboardingScaffold(child: tabs(context));
  }

  Widget tabs(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).textTheme.bodyText1!.color,
            unselectedLabelColor: Theme.of(context).textTheme.caption!.color,
            tabs: <Widget>[
              Tab(
                text: 'Login',
              ),
              // Tab(
              //   text: 'Join',
              // ),
            ],
          ),
          Expanded(
            child: TabBarView(
//              controller: _tabController,
              children: <Widget>[
                Center(
                  child: LoginFormDefault(),
                ),
                // Center(
                //   child: JoinRequestForm(),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
