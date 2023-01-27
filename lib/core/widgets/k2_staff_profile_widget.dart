import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';

extension K2StaffProfileWidgets on K2StaffProfile {
  Widget avatarWidget(
      {double circleAvatarRadius = 24.0, IconData errorIcon = Icons.error}) {
    return CachedNetworkImage(
        imageUrl: avatar?.url ?? ' ',
        imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundImage: imageProvider,
              radius: circleAvatarRadius,
            ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(errorIcon));
  }
}
