import UIKit
import SwiftModule
import SwiftModuleWithPrebuiltDependency


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

let text = "This is an internal property in the app code!"
let swiftModuleText = SwiftModule.text
let swiftModuleWithPrebuiltDependencyText1 = SwiftModuleWithPrebuiltDependency.text1
let swiftModuleWithPrebuiltDependencyText2 = SwiftModuleWithPrebuiltDependency.text2

