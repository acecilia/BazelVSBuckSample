import Foundation

public let text = "Hello, World!"

public let textFileContent: String? = {
    let textFilePath = Bundle.main.url(forResource: "text_file", withExtension: "txt")
    if let textFilePath = textFilePath {
        return try? String(contentsOf: textFilePath, encoding: .utf8)
    } else {
        return nil
    }
}()
