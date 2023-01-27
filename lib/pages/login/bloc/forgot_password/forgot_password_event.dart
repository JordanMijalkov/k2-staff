import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A ForgotPasswordEvent base class to extend
abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object> get props => [];
}

/// A ForgotPasswordEvent indicating we need to request an Email Code
class FPEventSendCodeRequest extends ForgotPasswordEvent {
  final String email;

  FPEventSendCodeRequest({ required this.email});

  @override
  List<Object> get props => [email];
}

/// A ForgotPasswordEvent indicating we need to start the Forgot Password Flow
class FPEventInitialed extends ForgotPasswordEvent {}

