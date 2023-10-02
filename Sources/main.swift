import ArgumentParser
import Foundation


struct MakeWords: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "split input into words",
                                                    version: "0.1.0")
    
    @Argument(
        help: "A file to count lines in. If omitted, counts the lines of stdin.",
        completion: .file(), transform: URL.init(fileURLWithPath:))
    var inputFile: URL? = nil


    var fileHandle: FileHandle {
        get throws {
            guard let inputFile = inputFile else {
                return .standardInput
            }
            return try FileHandle(forReadingFrom: inputFile)
        }
    }


    mutating func run() throws {
        if let fileData = try fileHandle.readToEnd() {
            let fileContents = String(decoding: fileData, as: UTF8.self)
            print("grapheme clusters (~ characters): \(fileContents.count)")
        }

        let fileDisplayName = inputFile?.absoluteString ?? "<stdin>"
        print("makewords \(fileDisplayName)")

    }
}

MakeWords.main()