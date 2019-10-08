import UIKit
import SwiftModule
import SwiftModuleWithoutTests
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
let swiftModuleTextFileContent = SwiftModule.textFileContent
let swiftModuleTextFileContent2 = SwiftModule.textFileContent2
let swiftModuleWithoutTestsText = SwiftModuleWithoutTests.text
let swiftModuleWithPrebuiltDependencyText1 = SwiftModuleWithPrebuiltDependency.text1
let swiftModuleWithPrebuiltDependencyText2 = SwiftModuleWithPrebuiltDependency.text2

