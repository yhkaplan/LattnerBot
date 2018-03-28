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
    
    //TODO: refactor in functional way! change emoji
    public var emojiGraph: String {
        
        let emojiTotal = 20.0
        let swiftNum = Int(round((swiftPercentage / 100) * emojiTotal))
        let objcNum = Int(round((objcPercentage / 100) * emojiTotal))
        
        var graph = ""
        for _ in 0 ..< swiftNum {
            graph += "🔶"
        }
        for _ in 0 ..< objcNum {
            graph += "🔷"
        }
        
        return graph
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
