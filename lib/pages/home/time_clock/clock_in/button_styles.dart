import 'package:flutter/material.dart';

final ButtonStyle selectedoutlineButtonStyle = OutlinedButton.styleFrom(
  // primary: Colors.black87,
  // minimumSize: Size(88, 36),
  // padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  side: BorderSide(color: Colors.greenAccent, width: 2.0)
);

final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
  // primary: Colors.black87,
  // minimumSize: Size(88, 36),
  // padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
//  side: BorderSide(color: Colors.greenAccent, width: 2.0)
);

// .copyWith(
//   side: MaterialStateProperty.resolveWith<BorderSide>(
//     (Set<MaterialState> states) {
//       if (states.contains(MaterialState.selected))
//         return BorderSide(
//           color: Colors.greenAccent,
//           width: 2,
//         );
//       return null; // Defer to the widget's default.
//     },
//   ),
// );