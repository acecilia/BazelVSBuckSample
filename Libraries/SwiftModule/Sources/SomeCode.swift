import Foundation

public let text = "Hello, World!"

private let resourcesBundle: Bundle? = {
    let moduleName = String(reflecting: SomeClass.self).components(separatedBy:".").first!
    let resourceBundleName = moduleName + "Resources"
    guard let bundleURL = Bundle.main.url(forResource: resourceBundleName, withExtension: "bundle"),
        let bundle = Bundle(url: bundleURL) else {
            return nil
    }
    return bundle
}()

public let textFileContent: String? = {
    let textFilePath = resourcesBundle?.url(forResource: "text_file", withExtension: "txt")
    if let textFilePath = textFilePath {
        return try? String(contentsOf: textFilePath, encoding: .utf8)
    } else {
        return nil
    }
}()

public let textFileContent2: String? = {
    let textFilePath = resourcesBundle?.url(forResource: "text_file2", withExtension: "txt")
    if let textFilePath = textFilePath {
        return try? String(contentsOf: textFilePath, encoding: .utf8)
    } else {
        return nil
    }
}()

/// Class used for obtaining the module name
private class SomeClass {
}
