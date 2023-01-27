import UIKit
import Flutter
import SecureUnlock

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, SecureUnlockDelegate {
  //  var sink: FlutterEventSink?

    func secureUnlockClientID() -> Int {
        return 0;
    }
    
    func secureUnlockLoginForOrganization(_ organization: Int?) -> Login? {
        return Login(id:0, token:"", key:"", certificate: "");
    }    
    static var channel = FlutterMethodChannel()
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller = window?.rootViewController as! FlutterViewController
      let applePayChannel = FlutterMethodChannel(name: "com.kangarootime.k2.workforce/suppressApplePay", binaryMessenger: controller.binaryMessenger)
        applePayChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch call.method {
        case "DisableApplyPay":
            PassKitHelper.suppressApplePay()
        default:
            break
        }
        })

      SecureUnlockManager.shared.start()
      SecureUnlockManager.shared.delegate = self
      BeaconManager.shared.startMonitoring()

      AppDelegate.channel = FlutterMethodChannel(name: "com.kangarootime.k2.workforce/kisi_secure_unlock", binaryMessenger: controller.binaryMessenger)
//      let kisiEventChannel = FlutterEventChannel(name: "kisi_secure_unlock_ios", binaryMessenger: registrar.messenger())
        
      AppDelegate.channel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "BeaconManagerStart":
                print("Ranging.....")
                BeaconManager.shared.startRanging()
            case "BeaconManagerStop":
                BeaconManager.shared.stopRanging()
            default:
                break
            }
        })
      
            let beaconLocks = BeaconManager.shared.enteredBeaconsLocks.flatMap { $0.1 as? [BeaconLock] }
      AppDelegate.channel.invokeMethod("BeaconLockIdPass", arguments: beaconLocks)
      
    NotificationCenter.default.addObserver(self, selector: #selector(didEnterNotification), name: .BeaconManagerDidEnterRegionNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didExitNotification), name: .BeaconManagerDidExitRegionNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }  
    @objc func didEnterNotification(){
//        print("Did Enter Notification")

        AppDelegate.channel.invokeMethod("enterNotification", arguments: "enterNotification")
    }
    @objc func didExitNotification(){
        AppDelegate.channel.invokeMethod("exitNotification", arguments: "exitNotification")
    }
    @objc func didBecomeActive(notification: NSNotification) {
        print("....DidBecomeActive...")
        BeaconManager.shared.startRanging()
   
        let beaconLocks = BeaconManager.shared.enteredBeaconsLocks.flatMap { $0.1 as? [BeaconLock] }
        print(beaconLocks)
        AppDelegate.channel.invokeMethod("BeaconLockIdPass", arguments: "id: 14531, oneTimePassword: 315")        
    }
    @objc func didEnterBackground(notification: NSNotification) {
        BeaconManager.shared.stopRanging()
    }
  func secureUnlockSuccess(online: Bool, duration: TimeInterval) {

      AppDelegate.channel.invokeMethod("secureUnlockSuccess", arguments: online)
        // Callback when unlock succeeds.
        // Online parameter indicates if it was an online or offline unlock.
        // Duration parameter tells how long the unlock took
    }
    
    func secureUnlockFailure(error: SecureT2UError, duration: TimeInterval) {
                let beaconLocks = BeaconManager.shared.enteredBeaconsLocks.flatMap { $0.1 as? [BeaconLock] }
      // guard let sink = sink else { return }

        if (beaconLocks.count > 0) {
            beaconLocks.forEach { item in
                if (item.count > 0) {
                    print(item[0].oneTimePassword)
                    AppDelegate.channel.invokeMethod("BeaconLockIdPass", arguments: item[0].id)   
                }
            }
        }
            
        AppDelegate.channel.invokeMethod("secureUnlockFailure", arguments: duration)
        // Unlock failed
        // Note that if because of needsDeviceOwnerVerification you should prompt user to unlock phone or setup passcode.
        // Duration parameter tells how long the unlock took
    }
    func secureUnlockFetchCertificate(login: Int, reader: Int, online: Bool, completion: @escaping (Result<String, SecureT2UError>) -> Void) {
        AppDelegate.channel.invokeMethod("secureUnlockFetchCertificate", arguments: login)
        // If online use certificate that was returned when login was created. See scram credentials property https://api.kisi.io/docs#/operations/createLogin.
        // If offline you need to fetch a short lived offline certificate for the given reader (beacon) id. See offline certificate https://api.kisi.io/docs#/operations/fetchOfflineCertificate.
    }
    func secureUnlockLoginIDForOrganization(_ organization: Int?) -> Int? {
        AppDelegate.channel.invokeMethod("secureUnlockLoginIDForOrganization", arguments: organization)
        return organization
        // Login id callback. 
        // If you only support 1 login you can ignore the organization property and simply return the login id for the logged in user. Otherwise you must find the login id for the given organization.
    }
    
    func secureUnlockPhoneKeyForLogin(_ login: Int) -> String? {
        // Phone key callback. 
        AppDelegate.channel.invokeMethod("secureUnlockPhoneKeyForLogin", arguments: login)
        return "\(login)"
        // The phone key is returned when you create a login object. See https://api.kisi.io/docs#/operations/createLogin.
    }
}
