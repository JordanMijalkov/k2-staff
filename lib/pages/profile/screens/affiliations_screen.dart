import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/colors.dart';
import 'profile_menu_phone.dart';

class AffiliationsScreen extends StatefulWidget {

  @override
  _AffiliationsScreenState createState() => _AffiliationsScreenState();
}

class _AffiliationsScreenState extends State<AffiliationsScreen> {

  Widget _affiliationWidget(String url, String name,
      {bool hasLabel = false, String? labelText}) {
    return ListTile(
        leading: CachedNetworkImage(
            imageUrl: url, //??
               // 'https://s1.thcdn.com/productimg/1600/1600/12024631-1474653879765789.jpg',
            // TODO Probably need a 'placeholder' if no URL is set
            imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                  radius: 24.0,
                ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error)),
        title: hasLabel
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: K2Colors.teal,
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(6.0))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                          child: Text('Entity',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: K2Colors.white)),
                        ),
                      )),
                ],
              )
            : Text(name));
  }

  List<Widget> _affiliationWidgets() {

    K2StaffProfile _k2staffProfile = context.read<AuthenticationCubit>().state.staffProfile!;

    List<Widget> _widgets = [
      Text("Affiliations", style: Theme.of(context).textTheme.headline5),
      Divider()
    ];
    _k2staffProfile.roleship?.scopes?.forEach((element) {
      switch (element.runtimeType) {
        case K2Entity:
          {
            final _element = element as K2Entity;
            _widgets.add(_affiliationWidget(
                _element.avatar!.url!, _element.name!,
                hasLabel: true, labelText: 'Entity'));
            break;
          }
        case K2Center:
          {
            final _element = element as K2Center;
            String? _myPrimary = _k2staffProfile.primaryCenter?.id;
            if (_myPrimary != null) {
              if (_myPrimary == _element.id) {
                _widgets.add(_affiliationWidget(
                    _element.avatar!.url!, _element.name!,
                    hasLabel: true, labelText: 'Primary'));
              } else {
                _widgets.add(
                    _affiliationWidget(_element.avatar!.url!, _element.name!,));
              }
            }
            break;
          }
        default:
          {
            // Add nothing if unknown type
            break;
          }
      }
    });


    final _lastWidget = Padding(
        padding: EdgeInsets.only(top: 12),
        child: TextButton(
            onPressed: () {
              setState(() {
                // BlocProvider.of<PhoneScreenBloc>(context)
                //     .add(Navigate(page: ProfileMenuPhone()));
              });
            },
            child: Text(
              "Cancel",
            )));

    _widgets.add(_lastWidget);
    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _affiliationWidgets(),
          ),
        ),
      ),
    );
  }
}
