import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/colors.dart';
import 'package:k2_staff/core/widgets/clock_icon.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
import 'package:k2_staff/pages/home/v2/cubit/staff_cubit.dart';
import 'package:k2_staff/pages/home/v2/k2_summary_time_item.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:intl/intl.dart';

class ClockOutScreen extends StatefulWidget {
  ClockOutScreen({
    required this.centerId,
    this.currentShift,
    this.openTimeEntry,
    this.timeEntries,
    Key? key}) : super(key: key);

  final String centerId;
  final K2Shift? currentShift;
  final K2TimeEntry? openTimeEntry;
  final List<K2TimeEntrySummaryItem>? timeEntries;

  @override
  State<ClockOutScreen> createState() => _ClockOutScreenState();
}

class _ClockOutScreenState extends State<ClockOutScreen> {
  final DateFormat timeFormatter = new DateFormat('hh:mm:ss a');


  // final K2Person? staffMember = QR.params['employee']!.valueAs<K2Person>();
  // final K2Shift? currentShift = null == QR.params['shift'] ? null : QR.params['shift']!.valueAs<K2Shift>();
  // final K2TimeEntry? openTimeEntry = QR.params['openTimeEntry']!.valueAs<K2TimeEntry>();
  // final List<K2TimeEntrySummaryItem>? timeEntries = QR.params['logEntries']!.valueAs<List<K2TimeEntrySummaryItem>>();

  final CarouselController _controller = CarouselController();
  ValueNotifier valueNotifier = ValueNotifier(0);

  @override
  void dispose() {
    super.dispose();
    valueNotifier.dispose();
  }
    
  @override
  Widget build(BuildContext context) {
    K2StaffProfile staffMember = context.read<AuthenticationCubit>().state.staffProfile!;

    final _size = MediaQuery.of(context).size;

    double width = min(353, _size.width*.90);

    return BlocProvider(
      create: (_) => StaffCubit(
        centerId: widget.centerId,
        staffMember: staffMember,
        currentShift: widget.currentShift),
      child: Builder(
        builder: (context) {
          return KTScaffold(
            backgroundColor: Colors.grey[200],
              showIcon: true,
              title: "",
              body: Center(
                child: Wrap(children: [
                  BlocBuilder<StaffCubit, StaffState>(
                            builder: (context, state) {
                              return Column(
                    children: [
                      Container(
                          width: 450,
                          // padding: const EdgeInsets.symmetric(vertical: 60.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                color: Colors.transparent// Theme.of(context).colorScheme.onSurface,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "Clock Out",
                                      style: Theme.of(context).textTheme.headline1,
                                    ),
                                    SizedBox(
                                      height: 18,
                                    ),
                                    ClockIcon(iconColor: Colors.redAccent),
                                    SizedBox(
                                      height: 48,
                                    ),
                                    Container(
                                      //                            color: Theme.of(context).primaryColor,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.secondary,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10)),
                                      ),

                                      child: SizedBox(
                                          height: 40,
                                          width: width,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                if (null != widget.openTimeEntry)
                                                  context.read<StaffCubit>().clockOut(widget.openTimeEntry!);
                                                  QR.navigator.replaceAll('/clockOutSuccess');

                                              },
                                              child: Text('Clock Out Now'),
                                              style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context)
                                                      .colorScheme
                                                      .secondary))),
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    SizedBox(
                                        height: 40,
                                        width: width,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              QR.navigator.replaceAll('/home');
                                            },
                                            child: Text(
                                              'Cancel',
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey))),
                                    SizedBox(
                                      height: 48,
                                    ),
                                  ])
                            ),
                          SizedBox(height: 24,),
                          Container(width: width,
                            child:
                              Column(mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Today at a glance", style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.redAccent),),
                                  ),
                          CarouselSlider.builder(
                itemCount: widget.timeEntries?.length ?? 0,
                carouselController: _controller,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                            Expanded(flex: 1, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              SizedBox(width: 24, child: ClockIcon()),
                              Padding(
                                padding: const EdgeInsets.only(left:16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.timeEntries![itemIndex].type!),
                                    Text(timeFormatter.format(DateTime.parse(widget.timeEntries![itemIndex].time!).toLocal())
                                      )
                                      //timeEntries[itemIndex].time)
                                  ],
                                ),
                              )
                              ],)),
                            VerticalDivider(),
                            Expanded(flex: 1, child:Center(child: Text('${widget.timeEntries![itemIndex].position}', textAlign: TextAlign.center,)))
                            // Expanded(flex: 1, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [ Text("1")
                            //     //Text('${widget.timeEntries![itemIndex].position}')
                            //     ],))
                          ],),
                        ),
                      );
                    }, 
                    options: CarouselOptions(
                    autoPlay: false,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: false,
                    height: 100,
                    viewportFraction: 1.0,
                    // height: MediaQuery.of(context).size.height <= 450.0
                    //     ? 350.0
                    //     : 450.0,
                    onPageChanged: (index, reason) {
                             valueNotifier.value = index;
                    })),
                                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.timeEntries!.asMap().entries.map((entry) {
                        return _childIndicator(entry);
                      }).toList()),
                                ],
                              ),
                            
                          ),

                    ],
                  );
                            })
                ]),
              ));
        }
      ),
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

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}  

