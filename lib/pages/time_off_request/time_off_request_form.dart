import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/pages/home/v2/k2_confirmation_dialog.dart';
import 'package:k2_staff/pages/time_off_request/cubit/time_off_request_cubit.dart';
import 'package:measured_size/measured_size.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeOffRequestForm extends StatefulWidget {
  const TimeOffRequestForm({Key? key}) : super(key: key);

  @override
  _TimeOffRequestFormState createState() => _TimeOffRequestFormState();
}

class _TimeOffRequestFormState extends State<TimeOffRequestForm> {
  final _descriptionTextController = TextEditingController();
  final DateFormat dateFormatter = new DateFormat('yyyy-MM-dd');
  final DateFormat dateFormatter2 = new DateFormat('E MMM d');
  final DateFormat dateFormatter3 = new DateFormat('MMM d');

  var _durationDropdownOptions;

  String? _durationSelection = 'All Day';
  double _height = 40;
  DateTime? _selectedDate;
  DateTimeRange? _dateTimeRange;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  bool _hasDescription = false;
  bool _withinTwoWeeks = false;

  @override
  void initState() {
    super.initState();

    _startTime = TimeOfDay.now();
    _endTime = TimeOfDay.now();

    _descriptionTextController.addListener(() {
      final self = _descriptionTextController;
      setState(() {
        _hasDescription = self.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    _durationDropdownOptions = <String>[
      'All Day',
      'Partial Day',
      'Multiple Days'
    ].map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();

    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 24.0),
                child: Text("Request Time Off",
                    style: Theme.of(context).textTheme.headline3),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MeasuredSize(
                    onChange: (Size size) {
                      setState(() {
                        _height = size.height;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _durationSelection,
                          //   disabledHint: Text("disabled"),
                          onChanged: (String? newValue) {
                            setState(() {
                              _durationSelection = newValue;
                            });
                          },
                          items: _durationDropdownOptions,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 3.0, left: 14.0, bottom: 20.0),
                    child: Text(
                      "Duration",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 16.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _durationSelection == 'Multiple Days'
                          ? dateTimeRangePicker()
                          : datePicker();
                    },
                    child: Container(
                        width: double.infinity,
                        height: _height,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                              style: BorderStyle.solid,
                              width: 0.80),
                        ),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: _durationSelection == 'Multiple Days'
                                ? null == _dateTimeRange
                                    ? Text("Select Days")
                                    : Text(
                                        '${dateFormatter2.format(_dateTimeRange!.start)} - ${dateFormatter2.format(_dateTimeRange!.end)}')
                                : null == _selectedDate
                                    ? Text("Select Date")
                                    : Text(
                                        dateFormatter2.format(_selectedDate!)))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 3.0,
                        left: 14.0,
                        bottom: _withinTwoWeeks ? 6.0 : 20.0),
                    child: Text(
                      "Date",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  if (_withinTwoWeeks)
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, bottom: 14.0),
                      child: Text('Submission is under 2 weeks notice',
                          style: TextStyle(
                            color: Colors.red,
                          )),
                    )
                ],
              ),
              if (_durationSelection == 'Partial Day')
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var newTime =
                                  await _selectTime(context, _startTime);
                              if (null != newTime) {
                                setState(() {
                                  _startTime = newTime;
                                });
                              }
                            },
                            child: Container(
                                width: double.infinity,
                                height: _height,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      style: BorderStyle.solid,
                                      width: 0.80),
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                        Text('${_startTime.format(context)}'))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0, left: 14.0, bottom: 20.0),
                            child: Text(
                              "Start Time",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var newTime =
                                  await _selectTime(context, _endTime);
                              if (null != newTime) {
                                setState(() {
                                  _endTime = newTime;
                                });
                              }
                            },
                            child: Container(
                                width: double.infinity,
                                height: _height,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      style: BorderStyle.solid,
                                      width: 0.80),
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                        Text('${_endTime.format(context)}'))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0, left: 14.0, bottom: 20.0),
                            child: Text(
                              "End Time",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              if (toDouble(_startTime) > toDouble(_endTime))
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, bottom: 14.0),
                  child: Text('End time is before start time',
                      style: TextStyle(
                        color: Colors.red,
                      )),
                ),
              TextFormField(
                maxLines: 3,
                minLines: 3,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),

                  //hintText: 'First Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add a short reason why...';
                  }

                  return null;
                },
                controller: _descriptionTextController,
                textInputAction: TextInputAction.done,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 3.0, left: 14.0, bottom: 20.0),
                child: Text(
                  "Description (Required)",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),

              Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text('Existing request for selected date(s):'),
                ),
                
                BlocBuilder<TimeOffRequestCubit, TimeOffRequestState>(
                  builder: (context, state) {
                    if (state.existingTimeOffRequests.isEmpty)
                      return Text('  None');
                    else
                      return _displayExistingRequests(state.existingTimeOffRequests);
                  },
                )
              ],),

              SizedBox(height: 12,),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                      style: new ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              width: 2.0, color: colorScheme.primary))),
                      child: Text("Back"),
                      onPressed: () =>
                          context.read<TimeOffRequestCubit>().resetState()),
                ),
                SizedBox(width: 15.0),
                Expanded(
                    child: ElevatedButton(
                        onPressed: _submitEnabled()
                            ? () => _submitRequest(context)
                            : null,
                        child: const Text('Submit')))
              ])
            ])));
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  Widget _displayExistingRequests(List<K2TimeOffRequest> requests) {
    DateTime startDate;
    DateTime endDate;

    List<Widget> rows = [];

    if (_durationSelection == 'Multiple Days') {
      if (null == _dateTimeRange) return Container();
      startDate = _dateTimeRange!.start;
      endDate = _dateTimeRange!.end.add(Duration(days: 1));
    }
    else {
      if (null == _selectedDate) return Container();
      startDate = _selectedDate!;
      endDate = _selectedDate!.add(Duration(days: 1));
    }

    DateTime currentDay = startDate;
    while (currentDay.isBefore(endDate)) {
      print(dateFormatter3.format(currentDay));
      int approved = 0;
      int pending = 0;

      requests.forEach((request) { 
        DateTime requestStart = DateTime.parse(request.startTime!);
        DateTime requestEnd = DateTime.parse(request.endTime!);

        if (currentDay.isBetween(DateTime.parse(request.startTime!), DateTime.parse(request.endTime!)) ?? false) {
          if (request.status == K2TimeOffRequestStatus.PENDING) pending++;
          if (request.status == K2TimeOffRequestStatus.APPROVED) approved++;
        }
      });

//      if (approved > 0 || pending > 0)
        rows.add(Row(
          children: [
            Text('${dateFormatter3.format(currentDay)}: '),
            Icon(Icons.check_circle_outline, color: Colors.green, size: 14,),
            Text(' Approved ($approved) '),
            Icon(Icons.help_outline, color: Colors.orange, size: 14,),
            Text(' Pending ($pending) '),
            Text('Total: ${approved+pending}', style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ));

      currentDay = currentDay.add(Duration(days:1));
    }

    if (rows.isEmpty)
      return Container();
    else
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows,);
    
  }

  void _getCurrentTimeOffRequests() {
    K2StaffProfile me = context.read<AuthenticationCubit>().state.staffProfile!;
    DateTime startDate;
    DateTime endDate;

    if (_durationSelection == 'Multiple Days') {
      if (null == _dateTimeRange) return;
      startDate = _dateTimeRange!.start;
      endDate = _dateTimeRange!.end;
    }
    else {
      if (null == _selectedDate) return;
      startDate = _selectedDate!;
      endDate = _selectedDate!;
    }

    context.read<TimeOffRequestCubit>().getExistingTimeOffRequests(me, startDate, endDate);
  }

  void _submitRequest(BuildContext context) {
    K2StaffProfile me = context.read<AuthenticationCubit>().state.staffProfile!;

    if (_durationSelection == 'Partial Day') {
      _dateTimeRange = DateTimeRange(
          start: _selectedDate!.add(
              Duration(hours: _startTime.hour, minutes: _startTime.minute)),
          end: _selectedDate!
              .add(Duration(hours: _endTime.hour, minutes: _endTime.minute)));
    }

    context.read<TimeOffRequestCubit>().createTimeOffRequest(
        me,
        _durationSelection!,
        _selectedDate,
        _dateTimeRange,
        _descriptionTextController.text);
  }

  bool _submitEnabled() {
    if (!_hasDescription) return false;

    switch (_durationSelection) {
      case 'All Day':
        if (null != _selectedDate) return true;
        break;
      case 'Partial Day':
        if (null != _selectedDate && _startTime != _endTime) return true;
        break;
      case 'Multiple Days':
        if (null != _dateTimeRange) return true;
        break;
    }

    return false;
  }

  dateTimeRangePicker() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDateRange: DateTimeRange(
        end: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 13),
        start: DateTime.now(),
      ),
    );
    if (picked != null && picked != _dateTimeRange) {
      setState(() {
        _dateTimeRange = picked;
         _getCurrentTimeOffRequests();
      });
    }
  }

  datePicker() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        if (picked.difference(DateTime.now()).inDays < 14)
          _withinTwoWeeks = true;
        else
          _withinTwoWeeks = false;

        _selectedDate = picked;
         _getCurrentTimeOffRequests();
      });
    }
  }

  Future<TimeOfDay?> _selectTime(BuildContext context, TimeOfDay state) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: state,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != state) {
      return timeOfDay;
    } else
      return null;
  }
}


extension DateTimeExtension on DateTime? {
  bool? isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isAfter(dateTime);
    }
    return null;
  }

  bool? isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isBefore(dateTime);
    }
    return null;
  }

  bool? isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    final date = this;
    if (date != null) {
      final isAfter = date.isAfterOrEqualTo(fromDateTime) ?? false;
      final isBefore = date.isBeforeOrEqualTo(toDateTime) ?? false;
      return isAfter && isBefore;
    }
    return null;
  }
}