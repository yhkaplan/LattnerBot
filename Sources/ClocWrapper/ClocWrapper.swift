import Foundation
import ShellOut

public enum ClocError: Error {
    case couldNotConvertStringToData
    case couldNotConvertJSONToObject
}

public func runCloc(for path: String, with operation: (Data) throws -> String) throws -> String {
    let rawOutputString = try shellOut(to: "cloc --include-lang='Swift','Objective C','C/C++ Header' --json \(path)")
    
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
