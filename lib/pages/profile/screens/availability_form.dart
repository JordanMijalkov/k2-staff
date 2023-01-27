import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AvailabilityForm extends StatefulWidget {
  @override
  _AvailabilityFormState createState() => _AvailabilityFormState();
}

class _AvailabilityFormState extends State<AvailabilityForm> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child:_mainForm(context))
        ],
      ),
      tablet: (BuildContext context) => _mainForm(context),
    );
  }

  _mainForm(context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Availability",
                          style: Theme.of(context).textTheme.headline5),
                      Divider(),
_dayRow("Monday       "),
Divider(),
_dayRow("Tuesday      "),
Divider(),
_dayRow("Wednesday"),
Divider(),
_dayRow("Thursday    "),
Divider(),
_dayRow("Friday         "),
Divider(),
_dayRow("Saturday    "),
Divider(),
_dayRow("Sunday       "),

                    ]))));
  }

  _dayRow(String dayOfWeek) {
    return
                          Row(children: [
                        Expanded(
                            child: Wrap(
                                runAlignment: WrapAlignment.center,
                                children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(dayOfWeek),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Placeholder()
                                      // CustomSwitch(
                                      //   activeColor:
                                      //       Theme.of(context).secondaryHeaderColor,
                                      //   value: isSwitched,
                                      //   onChanged: (value) {
                                      //     setState(() {
                                      //       isSwitched = value;
                                      //     });
                                      //   },
                                      // ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: Container(
                                      width: 250,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          border: Border.all(
                                            color: Colors.black26,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Row(
                                        children: [
                                          TextButton(
                                            child: Text("5:00 AM" ),
                                            onPressed: () async {
                          //                     DatePicker.showTime12hPicker(context,
                          //     showTitleActions: true, onChanged: (date) {
                          //   print('change $date');
                          // }, onConfirm: (date) {
                          //   print('confirm $date');
                          // }, currentTime: DateTime.now());


                                              // var datePicked = await DatePicker
                                              //     .showSimpleDatePicker(
                                              //   context,
                                              //   pickerMode:
                                              //       DateTimePickerMode.datetime,
                                              //   // initialDate: DateTime(1994),
                                              //   // firstDate: DateTime(1960),
                                              //   // lastDate: DateTime(2012),
                                              //   dateFormat: "HH:mm",
                                              //   locale:
                                              //       DateTimePickerLocale.en_us,
                                              //   looping: true,
                                              // );
                                            },
                                          ),
                                          Text(">"),
                                          FlatButton(
                                            child: Text("9:00 PM"),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ClipOval(
                                      child: Material(
                                          color: Colors.purple, // button color
                                          child: SizedBox(
                                              width: 32,
                                              height: 32,
                                              child: Icon(
                                                Icons.plus_one,
                                                color: Colors.white,
                                              ))))
                                ],
                              )
                            ]))
                      ]);
  }
}
