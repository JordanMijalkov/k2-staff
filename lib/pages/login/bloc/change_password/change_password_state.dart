import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A base ChangPasswordState class to extend
abstract class ChangePasswordState extends Equatable {
  ChangePasswordState();

  @override
  List<Object?> get props => [];
}

/// A ChangePasswordState indicating we need to show the start of the
/// change password flow.
class ChangePasswordStateDefault extends ChangePasswordState {}

/// A ChangePasswordState indicating we ar waiting on a request/response
class ChangePasswordStateLoading extends ChangePasswordState {}

/// A ChangePasswordState indicating successful password change
class ChangePasswordStateSuccess extends ChangePasswordState {}

/// A ChangePasswordState indicating an error occurred while attempting to update
/// passwords
class ChangePasswordStateError extends ChangePasswordState {
  final String? error;

  ChangePasswordStateError({required this.error});

  @override
  List<Object?> get props => [error];

}
