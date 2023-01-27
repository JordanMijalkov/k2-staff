import 'package:flutter/material.dart';
import 'package:k2_staff/pages/profile/screens/change_pin_form.dart';
import 'change_password_form.dart';

class SecurityForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

 


     return 
    
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
            labelColor: Theme.of(context).textTheme.bodyText1!.color,
            indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(icon: Text("Password")),
                Tab(icon: Text("PIN")),
              ],
            ),

            Expanded(
          child: TabBarView(
//              controller: _tabController,
            children: <Widget>[
              Center(
                child: ChangePasswordForm(),
              ),
              Center(
                child: ChangePinForm(),
              ),
            ],
          ),
        )

          ]))
        )
      )
    );
  }}