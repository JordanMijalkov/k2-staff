import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_staff/pages/login/bloc/login_bloc/bloc.dart';

class JoinInviteSentDialog extends StatelessWidget {
  static const double padding = 16;
//  static const double avatarRadius = 66;

  final String? centerName;
  JoinInviteSentDialog({this.centerName});


  @override
  Widget build(BuildContext context) {
//    String title = "test";

        return     Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
  padding: EdgeInsets.all(24),
//  margin: EdgeInsets.only(top: avatarRadius),
  decoration: new BoxDecoration(
    color: Colors.white,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(padding),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10.0,
        offset: const Offset(0.0, 10.0),
      ),
    ],
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min, // To make the card compact
    children: <Widget>[
      Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 48),
      Text(
        "Success!",
        style: Theme.of(context).textTheme.headline5!.merge(TextStyle (color: Colors.greenAccent)),
      ),
      SizedBox(height: 24.0),
      Text(
        "Your request to join $centerName has been sent! You will receive an email with the next steps as soon as your request is verified!",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      SizedBox(height: 24.0),
      Align(
        alignment: Alignment.bottomCenter,
        child: FlatButton(
          onPressed: () {
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Close"),
        ),
      ),
    ],
  ),
),
    );



    Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)), //this right here
              child:
Material(
        elevation: 6.0,
        child:
          Padding(padding: EdgeInsets.all(16), child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 48),
              Padding(padding: EdgeInsets.only(top:14, bottom:8),
              child: Text("Success!", style: Theme.of(context).textTheme.headline5!.merge(TextStyle (color: Colors.greenAccent)))),
              Expanded(child: Text("Your request to join [Center A] has been sent! You will receive an email with the next steps as soon as your request is verified!", style: Theme.of(context).textTheme.subtitle1)),
              Padding(padding: EdgeInsets.only(bottom: 38),
                child: FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();                                                  },
                                                  child: Text(
                                                    "Close",
                                                  ))
              )


          ],
          )
          ))


        );
  }
}

