import UIKit

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {

  var window: UIWindow?

  let text = "This is an internal property in the app delegate!"

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]?
  ) -> Bool {

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .red
    window?.rootViewController = UIViewController()
    window?.makeKeyAndVisible()

    return true
  }
}

public let text = "This is a public property in the app code!"

