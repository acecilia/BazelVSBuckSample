import UIKit
import SwiftModule // TODO: remove this (this is just a workaround to make tests work)

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = UIViewController()
    window?.makeKeyAndVisible()
    print(textFileContent)
    return true
  }
}