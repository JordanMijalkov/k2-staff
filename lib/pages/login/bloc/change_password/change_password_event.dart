import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A base ChangePasswordEvent class to extend
abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

/// A ChangePasswordEvent indicating we need to trigger the Change Password flow.
/// We should already have been emailed a confirmation code.
class ChangePasswordEventRequested extends ChangePasswordEvent {}

/// A ChangPasswordEvent indicating we need to try and process a password change
class ChangePasswordEventConfirmationRequested extends ChangePasswordEvent {
  final String? username;
  final String verificationCode;
  final String newPassword;

  ChangePasswordEventConfirmationRequested({
    required this.username,
    required this.verificationCode,
    required this.newPassword
  });

  @override
  List<Object?> get props => [username, verificationCode, newPassword];
}
