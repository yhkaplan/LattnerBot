import Foundation
import ShellOut

public enum ClocError: Error {
    case couldNotConvertStringToData
    case couldNotConvertJSONToObject
}

public typealias Operation = (Data) throws -> String

public func runCloc(for path: String, debug: Bool, operation: Operation) throws -> String {
    let rawOutputString = try shellOut(to: "cloc --include-lang='Swift','Objective C','C/C++ Header' --json \(path)")
    
    if debug { print("Raw output: \(rawOutputString)") }
    
    guard let data = rawOutputString.data(using: .utf8) else {
        throw ClocError.couldNotConvertStringToData
    }
    
    return try operation(data)
}

public func getResults(for data: Data) throws -> String {
    guard let clocResult = try? JSONDecoder().decode(ClocResult.self, from: data) else {
        throw ClocError.couldNotConvertJSONToObject
    }
    //TODO: make Swift orange
    return """
    Percentage of Swift: \(clocResult.percentage(of: clocResult.linesOfSwift))%
    Percentage of Obj-C: \(clocResult.percentage(of: clocResult.linesOfObjC))%
    """
}
