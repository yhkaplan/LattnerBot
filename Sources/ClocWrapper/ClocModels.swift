//
//  ClocModels.swift
//  LattnerBotPackageDescription
//
//  Created by Joshua Kaplan on 2018/03/03.
//

import Foundation

public struct ClocResult: Codable {
    public let sumTotal: LanguageResult
    public let swift: LanguageResult?
    public let objc: LanguageResult?
    
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

extension ClocResult {
    public func percentage(of language: LanguageResult?) -> Double {
        guard let language = language else { return 0.00 }
        
        return Double((language.linesOfCode / sumTotal.linesOfCode) * 100).roundedToTwoPlaces
    }
}
