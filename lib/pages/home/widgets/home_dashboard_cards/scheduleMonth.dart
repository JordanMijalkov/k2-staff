import 'dart:collection';
import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_staff/core/colors.dart';
import 'package:k2_staff/pages/home/cubit/schedule_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleMonthWidget extends StatefulWidget {
  // final K2DateTimeRange? dateRange;
  // final List<K2Shift>? shifts;

  ScheduleMonthWidget();

  @override
  _ScheduleMonthWidgetState createState() => _ScheduleMonthWidgetState();
}

class _ScheduleMonthWidgetState extends State<ScheduleMonthWidget> {
  //final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
//  CalendarController _calendarController;
  DateTime startDate = Jiffy().startOf(Units.MONTH).dateTime;
  DateTime endDate = Jiffy().endOf(Units.MONTH).dateTime;
  DateTime selectedDate = DateTime.now(); //.subtract(Duration(days: 2));
  // List<DateTime> markedDates = [
  //   DateTime.now().subtract(Duration(days: 1)),
  //   DateTime.now().subtract(Duration(days: 2)),
  //   DateTime.now().add(Duration(days: 4))
  // ];
  List<K2Shift> activeShifts = [];
  PageController? _pageViewController;

  K2DateTimeRange thisMonth = K2DateTimeRange(
      startTime: Jiffy().startOf(Units.MONTH).dateTime.toIso8601String(),
      endTime: Jiffy().endOf(Units.MONTH).dateTime.toIso8601String());

  final CarouselController _controller = CarouselController();
  ValueNotifier valueNotifier = ValueNotifier(0);

  late LinkedHashMap<DateTime, List<K2Shift>> _hashedShifts;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  onSelect(data) {
    print("Selected Date -> $data");
  }

  _monthNameWidget(monthName) {
    return Container(
      child: Text(monthName,
          style: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(fontStyle: FontStyle.italic)),
      padding: EdgeInsets.only(top: 8, bottom: 4),
    );
  }

  @override
  void initState() {
    super.initState();
//    _calendarController = CalendarController();
    // _pageViewController = PageController(viewportFraction: 1);
  }

  List<K2Shift> _getEventsForDay(DateTime day) {
    return _hashedShifts[day] ?? [];

    //shifts[day] ?? [];
    // List<K2Shift> shifts = [];
    // shifts?.forEach((e) {

    //   if (newEvents.contains(e)) {
    //     newEvents.add(e);
    //   } else {
    //     newEvents.putIfAbsent(Jiffy(e.startTime).startOf(Units.DAY).dateTime, () => [e]);
    //   }
    // });
  }

  // List<K2Shift> _getEvents(shifts) {
  //   List<K2Shift> newEvents = [];
  //   shifts?.forEach((e) {

  //     if (newEvents.contains(e)) {
  //       newEvents.add(e);
  //     } else {
  //       newEvents.putIfAbsent(Jiffy(e.startTime).startOf(Units.DAY).dateTime, () => [e]);
  //     }
  //   });
  //   return newEvents;
  // }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    double height = _size.height;
    double width = _size.width; // * .85;

    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        final _kEventSource = state.shifts;

        _hashedShifts = LinkedHashMap<DateTime, List<K2Shift>>(
          equals: isSameDay,
          hashCode: getHashCode,
        )..addAll(_kEventSource!);

        activeShifts = _getEventsForDay(_selectedDay);
        // ..addAll({
        //   kToday: [
        //     Event('Today\'s Event 1'),
        //     Event('Today\'s Event 2'),
        //   ],
        // });

        return Row(
          children: [
            Expanded(
              child: Container(
                  //padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 247, 251, 1),
                      // border: Border.all(
                      //   color: Colors.grewhiteen,
                      // ),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       "Schedule",
                      //       style: Theme.of(context).textTheme.headline6,
                      //     ),
                      //     InkWell(
                      //       child: Icon(Icons.calendar_today, size: 20),
                      //       onTap: () {
                      //         // BlocProvider.of<HomeNavBloc>(context)
                      //         //     .add(Navigate(page: ScheduleHomePage()));
                      //       },
                      //     )
                      //   ],
                      // ),
                      Container(
                        //padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          // border: Border.all(
                          //   color: Colors.grewhiteen,
                          // ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Container(
                            //   padding: EdgeInsets.all(20),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         '${DateFormat('MMM').format(_selectedDay)}',
                            //         style:
                            //             Theme.of(context).textTheme.headline6,
                            //       ),
                            //       InkWell(
                            //         // child: Icon(Icons.calendar_today, size: 20),
                            //         child: Image.asset(
                            //             'assets/images/arrow_right.png'),
                            //         onTap: () {
                            //           // BlocProvider.of<HomeNavBloc>(context)
                            //           //     .add(Navigate(page: ScheduleHomePage()));
                            //         },
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Divider(
                            //   color: Color.fromRGBO(0, 0, 0, 0.15),
                            // ),
                            // SizedBox(
                            //   height: 11,
                            // ),
                            TableCalendar<K2Shift>(
                              calendarBuilders: CalendarBuilders(
                                singleMarkerBuilder: (context, date, _) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(
                                            51, 103, 169, 1)), //Change color
                                    width: 5.0,
                                    height: 5.0,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1.5, vertical: 9),
                                  );
                                },
                              ),
                              rowHeight: 58,
                              headerVisible: true,
                              eventLoader:
                                  _getEventsForDay, // _getEvents(this.widget.shifts),
                              //       calendarController: _calendarController,
                              focusedDay: _focusedDay,
                              onDaySelected:
                                  (DateTime selectedDay, DateTime focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                  activeShifts = _getEventsForDay(selectedDay);
                                });
                                //setState(() {
                                // activeShifts = events.cast<K2Shift>();
                                // selectedDate = day;
                                //                      });
                              },
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDay, day);
                              },
                              firstDay: DateTime.utc(2010, 10, 16),
                              lastDay: DateTime.utc(2030, 3, 14),
                              // firstDay: Jiffy(thisMonth.startTime)
                              //     .dateTime, // ?? startDate,
                              // lastDay: Jiffy(thisMonth.endTime).dateTime, // ??
                              //endDate,
                              onPageChanged: (focusedDay) {
                                _focusedDay = focusedDay;
                              },
                              availableCalendarFormats: {
                                CalendarFormat.month: 'Month'
                              },
                              calendarFormat: CalendarFormat.month,
                              // calendarStyle: CalendarStyle(
                              //   selectedColor: K2Colors.secondary,
                              //   todayColor: K2Colors.blueyGrey,
                              //   markersColor: K2Colors.primaryHover,
                              //  ),
                            )
                          ],
                        ),
                      ),
                      // Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      _buildShiftDetails(activeShifts, width, height - 58 * 5 - 16 - 20 - 320,)
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNoEvents() {
    return Container(
        height: 100,
        padding: EdgeInsets.only(top: 20),
        width: double.infinity,
        child: Center(
          child: Text(
            'No Schedule',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget _buildShiftDetails(List<K2Shift> shifts, double width, double height) {
    return Column(
      children: [
        shifts.length < 1
            ? Container(
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No Shift on the selected days',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15.0, color: Color.fromRGBO(81, 97, 115, 0.75)),
                    ),
                    // SizedBox(height: 5,),
                    Image.asset('assets/images/person.png', fit: BoxFit.fill, height: height,),
                    SizedBox(height: 15,)
                  ],
                ))
            : ListView.separated(
                physics: ScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 13);
                },
                shrinkWrap: true,
                itemCount: shifts.length,
                itemBuilder: (BuildContext context, int index) {
                  // return Card(
                  //   elevation: 2,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //   ),
                  // child: Container(
                  return Container(
                    padding: EdgeInsets.only(left: 2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xFF1579C6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),

                    // height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        // BorderRadius.only(
                        //     topRight: Radius.circular(5.0),
                        //     bottomRight: Radius.circular(5.0)),
                        color: Colors.white,
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${shifts[index].k2class?.name ?? ''}${shifts[index].k2class?.name != null ? ' : ' : ''}${shifts[index].center?.name ?? ''}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                  '${DateFormat('EEEE, MMM dd, yyyy').format(_selectedDay)}'),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset('assets/images/shift.png'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Shift:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    ' ${Jiffy(shifts[index].startTime).format("h:mm a")} - ${Jiffy(shifts[index].endTime).format("h:mm a")}',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset('assets/images/utensils-alt.png'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Break:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    ' ${shifts[index].breakMinutes} minutes (Unpaid)',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset('assets/images/Position.png'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Position:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    ' ${shifts[index].position?.title ?? ''}',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset('assets/images/shift.png'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Note:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Flexible(
                                      child: Text(
                                    ' ${shifts[index].note ?? ''}',
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          )),
                    ),
                  );
                },
              ),
        // Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: shifts.asMap().entries.map((entry) {
        //       return _childIndicator(entry);
        //     }).toList())
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Shift Details:", style: TextStyle(fontSize: 16)),
        if (shifts.length <= 0) _buildNoEvents(),
        if (shifts.length > 0)
          Container(
              height: 100,
              padding: EdgeInsets.only(top: 20),
              width: double.infinity,
              child: PageView.builder(
                  controller: _pageViewController,
                  itemCount: (shifts.length / 2).ceil(),
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${Jiffy(shifts[index].startTime).format("h:mm a")} - ${Jiffy(shifts[index].endTime).format("h:mm a")}',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                                '${shifts[index].k2class?.name ?? ''}${shifts[index].k2class?.name != null ? ' : ' : ''}${shifts[index].center?.name ?? ''}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: K2Colors.blueyGrey))
                          ],
                        ),
                        if (shifts.length > index + 1 &&
                            shifts[index + 1] != null)
                          VerticalDivider(
                            indent: 12,
                            thickness: 2,
                            endIndent: 12,
                          ),
                        if (shifts.length > index + 1 &&
                            shifts[index + 1] != null)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${Jiffy(shifts[index + 1].startTime).format("h:mm a")} - ${Jiffy(shifts[index + 1].endTime).format("h:mm a")}',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  '${shifts[index].k2class?.name ?? ''}${shifts[index].k2class?.name != null ? ' : ' : ''}${shifts[index].center?.name ?? ''}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: K2Colors.blueyGrey))
                            ],
                          )
                      ],
                    );
                  })),
      ],
    );
  }

  Widget _childIndicator(childs) {
    return ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (context, value, child) {
          return GestureDetector(
              onTap: () => _controller.animateToPage(childs.key),
              child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: value == childs.key
                          ? K2Colors.dirtyPurple
                          : K2Colors.lightBlueyGrey)));
        });
  }

  getMarkedIndicatorWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(left: 1, right: 1),
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      ),
      Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      )
    ]);
  }

  dateTileBuilder(
      date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
    TextStyle normalStyle =
        TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(
        fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black87);
    TextStyle dayNameStyle = TextStyle(fontSize: 14.5, color: fontColor);
    List<Widget> _children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(),
          style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    if (isDateMarked == true) {
      _children.add(getMarkedIndicatorWidget());
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Colors.amber,
        shape: BoxShape.circle,
      ),
      child: Column(
        children: _children,
      ),
    );
  }

  @override
  void dispose() {
    //  _calendarController.dispose();
    super.dispose();
  }
}
