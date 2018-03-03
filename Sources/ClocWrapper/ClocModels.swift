//
//  ClocModels.swift
//  LattnerBotPackageDescription
//
//  Created by Joshua Kaplan on 2018/03/03.
//

import Foundation

public struct ClocResult: Codable {
    public let sumTotal: LanguageResult
    public let swift: LanguageResult
    public let objc: LanguageResult
    
    enum CodingKeys: String, CodingKey {
        case sumTotal = "SUM"
        case swift = "Swift"
        case objc = "Objective-C" //TODO: To check label
    }
}

public struct LanguageResult: Codable {
    public let linesOfCode: Int
    enum CodingKeys: String, CodingKey { case linesOfCode = "code" }
}

//TODO: reduce code below to one variable
extension ClocResult {
    public var percentageOfSwift: Double {
        return Double((swift.linesOfCode / sumTotal.linesOfCode) * 100).roundedToTwoPlaces
    }
    
    public var percentageOfObjC: Double {
        return Double((objc.linesOfCode / sumTotal.linesOfCode) * 100).roundedToTwoPlaces
    }
}
