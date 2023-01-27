part of 'application_cubit.dart';

enum ApplicationStatus { initializing, initialized }

class ApplicationState extends Equatable {
  const ApplicationState(
    this.appSettings,
    { 
    this.status = ApplicationStatus.initializing,
    this.appLocale = 'en_US',
    this.center,
    this.shift,
 //   this.staffMember,
    this.tz,
    // this.ldIdentity
   });

   final String appLocale;
  final ApplicationStatus status;
  final K2Center? center;
//  final K2StaffProfile? staffMember;
  final K2Shift? shift;
  final Location? tz;
  final K2AppSettings appSettings;
  // final LaunchdarklyFlutter? ldIdentity;

  ApplicationState copyWith({
    K2AppSettings? appSettings,
    ApplicationStatus? status,
    String? appLocale,
    K2Center? center,
    K2Shift? shift,
  //  K2StaffProfile? staffMember,
    Location? tz,
    // LaunchdarklyFlutter? ldIdentity
  }) {
    
    return ApplicationState(
      this.appSettings,
      status: status ?? this.status,
      appLocale: appLocale ?? this.appLocale,
      center: center ?? this.center,
      shift: shift ?? this.shift,
  //    staffMember: staffMember ?? this.staffMember,
      tz: tz ?? this.tz,
      // ldIdentity: ldIdentity ?? this.ldIdentity,
      );
  }

  @override
  List<Object?> get props => [status, appLocale, center, shift, tz, ];
}