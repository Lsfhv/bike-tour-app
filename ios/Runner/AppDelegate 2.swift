import UIKit
import Flutter
//import RaxelPulse
import GoogleMaps;

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
       GMSServices.provideAPIKey("AIzaSyApryzTKCbb-9EQKqFsK7HuGzxz1SFf-OI")
      //RPEntry.initialize(withRequestingPermissions: false)
      
      //let options = launchOptions ?? [:]
      //RPEntry.application(application, didFinishLaunchingWithOptions: options)
     // GMSServices.provideAPIKey(Bundle.main.object(forInfoDictionaryKey:"googleMapsApiKey") as? String ?? "");
//    GMSPlacesClient.provideAPIKey("AIzaSyA75AqNa-yxMDYqffGrN0AqyUPumqkmuEs")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

