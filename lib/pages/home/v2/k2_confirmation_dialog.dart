import 'package:flutter/material.dart';
import 'package:k2_staff/core/colors.dart';

class K2ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final Widget? primaryButton;
  final Widget? secondaryButton;

  const K2ConfirmDialog(
      {Key? key,
      required this.title,
      this.content = '',
      this.primaryButton,
      this.secondaryButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Color(0xff2e2e39),
                        fontWeight: FontWeight.w600,
                        fontFamily: "ProximaSoft",
                        fontStyle: FontStyle.normal,
                        fontSize: 21.0)),
                SizedBox(height: 16),
                if (content.isNotEmpty) Text(content),
                if (content.isNotEmpty)
                  SizedBox(
                    height: 36,
                  ),
                Row(
                  children: [
                    if (secondaryButton != null) secondaryButton!,
                    SizedBox(
                      width: 16,
                    ),
                    if (primaryButton != null) primaryButton!,
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

abstract class K2Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool expand;
  final Color buttonColor;
  final Color textColor;

  const K2Button(
      {Key? key,
      required this.onPressed,
      required this.buttonText,
      required this.expand,
      required this.buttonColor,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: expand ? double.infinity : null,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    onPressed != null
                        ? buttonColor
                        : buttonColor.withOpacity(0.5))),
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: TextStyle(color: textColor),
            )));
  }
}

class K2PrimaryButton extends K2Button {
  const K2PrimaryButton(
      {Key? key, onPressed, required buttonText, bool expand = false})
      : super(
            key: key,
            expand: expand,
            onPressed: onPressed,
            buttonText: buttonText,
            textColor: K2Colors.white,
            buttonColor: K2Colors.pinkRed);
}

class K2SecondaryButton extends K2Button {
  const K2SecondaryButton(
      {Key? key, onPressed, required buttonText, bool expand = false})
      : super(
            key: key,
            expand: expand,
            onPressed: onPressed,
            buttonText: buttonText,
            textColor: K2Colors.white,
            buttonColor: K2Colors.blueGrey);
}