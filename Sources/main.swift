import ArgumentParser
import Foundation


// foldAndTrim takes a word and, depending on the flags passed in, downcases it, folds non-latin
// diacritics and trims non-alphanumeric chars from the beginning and ending of the word.
// e.g. "Café." might become "cafe". Swift's `alphanumerics` enum includes alphabets, 
// syllabaries, ideographs, and digits but not emojis, mathematical symbols or
// things like $, etc.
func foldAndTrim(word: String, trim: Bool, downcase: Bool, foldDiacritics: Bool) -> String {
	var newWord = word
	var foldingOptions: NSString.CompareOptions = []
	if downcase {
		foldingOptions.insert(.caseInsensitive)
	}
	if foldDiacritics {
		foldingOptions.insert(.diacriticInsensitive)
	}
	if !foldingOptions.isEmpty {
		newWord = word.folding(options: foldingOptions, locale: Locale.current)
	}
	if trim {
		newWord = newWord.trimmingCharacters(in: .alphanumerics.inverted)
	}
	
	return newWord
}

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
        guard let fileData = try fileHandle.readToEnd() else {
            return
        }
        
        let fileContents = String(decoding: fileData, as: UTF8.self)
        let words = fileContents.components(separatedBy: .whitespacesAndNewlines).map{
            foldAndTrim(word: $0, trim:true, downcase:true, foldDiacritics:false)
        }.filter {
            $0.count > 0
        }
        
        for word in words {
            print("\(word)")
        }

    }
}

MakeWords.main()