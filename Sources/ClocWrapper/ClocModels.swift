//
//  ClocModels.swift
//  LattnerBotPackageDescription
//
//  Created by Joshua Kaplan on 2018/03/03.
//

import Foundation

public struct ClocResult: Decodable {
    private let swift: LanguageResult?
    private let objc: LanguageResult?
    private let objcHeader: LanguageResult?
    
    enum CodingKeys: String, CodingKey {
        case swift = "Swift"
        case objc = "Objective C"
        case objcHeader = "C/C++ Header"
    }
}

public struct LanguageResult: Decodable {
    public var code = 0
}

extension ClocResult {
    public var linesOfObjC: Int {
        return (objc?.code ?? 0) + (objcHeader?.code ?? 0)
    }
    
    public var linesOfSwift: Int {
        return swift?.code ?? 0
    }
    
    public var sumTotal: Int {
        return linesOfObjC + linesOfSwift
    }
    
    public var emojiGraph: String {
        return "".emojiLine("🔶", for: swiftPercentage).emojiLine("🔷", for: objcPercentage)
    }
    
    public var swiftPercentage: Double {
        return self.percentage(from: self.linesOfSwift)
    }
    
    public var objcPercentage: Double {
        return self.percentage(from: self.linesOfObjC)
    }
    
    public func percentage(from linesOfCode: Int) -> Double {
        return (Double(linesOfCode) / Double(sumTotal) * 100.00).roundedToTwoPlaces
    }
}

extension String {
    public func emojiLine(_ emoji: String, for percentage: Double) -> String {
        let outputLength = 20.0
        let count = Int(round((percentage / 100) * outputLength))
        
        var output = self
        for _ in 0 ..< count {
            output += emoji
        }
        return output
    }
}
