import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k2_flutter_core/k2_flutter_core_widgets.dart';
import 'package:k2_staff/pages/profile/models/emergency_contact.dart';
import 'package:responsive_builder/responsive_builder.dart';


class EmergencyContactForm extends StatefulWidget {
  final List<EmergencyContact> emergencyContacts;
  final VoidCallback? onTapAddAnother;

  EmergencyContactForm({this.emergencyContacts = const[], this.onTapAddAnother});

  @override
  _EmergencyContactFormState createState() => _EmergencyContactFormState();
}

class _EmergencyContactFormState extends State<EmergencyContactForm> {
  // static final _UsNumberTextInputFormatter _birthDate =
  //     new _UsNumberTextInputFormatter();

  String? phoneNumber;
  String? phoneIsoCode;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  onValidPhoneNumber(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      //  confirmedNumber = internationalizedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child: _mainForm(context))
        ],
      ),
      tablet: (BuildContext context) => _mainForm(context),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 250,
              child: TextBoxWithHeader(
                bottomPadding: 8,
                labelText: "First Name",
                hintText: "Yukon",
              ),
            ),
            Container(
              width: 250,
              child: TextBoxWithHeader(
                bottomPadding: 8,
                labelText: "Last Name",
                hintText: "Cornelius",
              ),
            ),
          ],
        ),
        Wrap(
          children: [
            TextBoxWithHeader(
              bottomPadding: 8,
              labelText: "Relationship",
              hintText: "Baby Mama",
            ),
            // InternationalPhoneInput(
            //     onPhoneNumberChange: onPhoneNumberChange,
            //     initialPhoneNumber: phoneNumber,
            //     initialSelection: phoneIsoCode ?? 'US',
            //     enabledCountries: ['+233', '+1']),
          ],
        ),
      ],
    );
  }

  _mainForm(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Emergency Contact",
                  style: Theme.of(context).textTheme.headline5),
              if (this.widget.emergencyContacts == null ||
                  this.widget.emergencyContacts.length == 0)
                Column(children: [
                  Divider(),
                  Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 12),
                    child: Center(
                      child: Text("No emergency contact"),
                    ),
                  )
                ])
              else if (this.widget.emergencyContacts != null &&
                  this.widget.emergencyContacts.length > 0)
                ...this.widget.emergencyContacts.map((e) => _buildForm()),
              Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        label: Text('Add Another'),
                        icon: Icon(Icons.add_circle),
       // textColor: activeTheme.textTheme.bodyText1.color,
                        onPressed: this.widget.onTapAddAnother,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + '/');
      if (newValue.selection.end >= 2) selectionIndex++;
    }
    if (newTextLength >= 5) {
      newText.write(newValue.text.substring(2, usedSubstringIndex = 4) + '/');
      if (newValue.selection.end >= 4) selectionIndex++;
    }
    if (newTextLength >= 9) {
      newText.write(newValue.text.substring(4, usedSubstringIndex = 8));
      if (newValue.selection.end >= 8) selectionIndex++;
    }
// Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
