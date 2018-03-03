import Foundation
import ShellOut

public enum ClocError: Error {
    case couldNotConvertStringToData
    case couldNotConvertJSONToObject
}

public final class ClocWrapper {
    public func runCloc(for path: String, with operation: (Data) throws -> String) throws -> String {
        let rawOutputString = try shellOut(to: "cloc --json \(path)", at: "~/")
        
        guard let data = rawOutputString.data(using: .utf8) else {
            throw ClocError.couldNotConvertStringToData
        }
        
        return try operation(data)
    }
    
    public func getResults(for data: Data) throws -> String {
        guard let clocResult = JSONDecoder().decode(ClocResult.self, from: data) else {
            throw ClocError.couldNotConvertJSONToObject
        }
        
        return """
        Percentage of Swift: \(clocResult.percentageOfSwift)
        Percentage of ObjC: \(clocResult.percentageOfObjC)
        """
    }
}
