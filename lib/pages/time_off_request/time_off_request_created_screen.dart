import 'package:flutter/material.dart';
import 'dart:math';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_staff/pages/time_off_request/cubit/time_off_request_cubit.dart';

class TimeOffRequestCreatedScreen extends StatelessWidget {
  const TimeOffRequestCreatedScreen({ Key? key }) : super(key: key);

  @override
   Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    double width = min(460, _size.width*.90); 

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
Icon(Icons.check_circle_outline, color: Colors.green, size: 180,),
SizedBox(height: 40,),
         SizedBox(
                                          height: 40,
                                          width: width,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                context.read<TimeOffRequestCubit>().resetState();
                                                QR.navigator.replaceAll('/home');
                                              },
                                              child: Text(
                                                'Finished!',
                                              ),
                                              ))
      ],
        
      ),
    );
  }
}