//
//  ClocWrapperTests.swift
//  LattnerBotPackageDescription
//
//  Created by Joshua Kaplan on 2018/03/03.
//

import XCTest
@testable import ClocWrapper

class ClocWrapperTests: XCTestCase {
    
    var clocOutput: String!
    var clocData: Data!
    var sumTotal: Int!
    var linesOfSwift: Int!
    var linesOfObjc: Int!

    
    override func setUp() {
        super.setUp()
        clocOutput = clocJSON
        clocData = clocOutput.data(using: .utf8)
        sumTotal = 3400 // Ignoring languages other than Obj-C and Swift
        linesOfSwift = 3330
        linesOfObjc = 70 // Header + regular obj-c
    }
    
    override func tearDown() {
        clocOutput = nil
        clocData = nil
        sumTotal = nil
        linesOfSwift = nil
        linesOfObjc = nil
        super.tearDown()
    }
    
    func test_dataDeserializationOfClocResult_isSuccessful() {
        guard let result = try? JSONDecoder().decode(ClocResult.self, from: clocData) else {
            XCTFail("Deserialization failure"); return
        }
        
        XCTAssertEqual(sumTotal, result.sumTotal)
        XCTAssertEqual(linesOfSwift, result.linesOfSwift)
        XCTAssertEqual(linesOfObjc, result.linesOfObjC)
    }
    
    func test_roundedToTwoPlaces_returnsCorrectFigure() {
        XCTAssertEqual(3400.00, Double(sumTotal).roundedToTwoPlaces)
        XCTAssertEqual(3330.00, Double(linesOfSwift).roundedToTwoPlaces)
        XCTAssertEqual(70.00, Double(linesOfObjc).roundedToTwoPlaces)
    }
    
    func test_percentageOf_returnsCorrectFigure() {
        guard let result = try? JSONDecoder().decode(ClocResult.self, from: clocData) else {
            XCTFail("Deserialization failure"); return
        }
        
        XCTAssertEqual(result.percentage(from: result.linesOfObjC), 2.06)
        XCTAssertEqual(result.percentage(from: result.linesOfSwift), 97.94)
        XCTAssertEqual(result.percentage(from: result.sumTotal), 100.00)
    }
}
