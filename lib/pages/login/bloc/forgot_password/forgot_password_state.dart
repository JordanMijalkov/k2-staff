import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ForgotPasswordState  extends Equatable {
  ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class FPStateInitial extends ForgotPasswordState {}

class FPStateCodeSent extends ForgotPasswordState {
  final String email;

  FPStateCodeSent({required this.email});

  @override
  List<Object> get props => [email];
}

class FPStateSendingCode extends ForgotPasswordState {}

class FPStateCodeSentError extends ForgotPasswordState {
  final String? error;

  FPStateCodeSentError({required this.error});

  @override
  List<Object?> get props => [error];

}
