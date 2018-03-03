//
//  ClocWrapperTests.swift
//  LattnerBotPackageDescription
//
//  Created by Joshua Kaplan on 2018/03/03.
//

import XCTest
import ClocWrapper

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
        sumTotal = 4501
        linesOfSwift = 3330
        linesOfObjc = 53
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
        
        XCTAssertEqual(sumTotal, result.sumTotal.linesOfCode)
        XCTAssertEqual(linesOfSwift, result.swift?.linesOfCode)
        XCTAssertEqual(linesOfObjc, result.objc?.linesOfCode)
            
    }
    
    func test_roundedToTwoPlaces_returnsCorrectFigure() {
        XCTAssertEqual(4501.00, Double(sumTotal).roundedToTwoPlaces)
        XCTAssertEqual(3330.00, Double(linesOfSwift).roundedToTwoPlaces)
        XCTAssertEqual(53.00, Double(linesOfObjc).roundedToTwoPlaces)
    }
    
    func test_percentageOf_returnsCorrectFigure() {
        guard let result = try? JSONDecoder().decode(ClocResult.self, from: clocData) else {
            XCTFail("Deserialization failure"); return
        }
        
        XCTAssertEqual(result.percentage(of: result.objc), 1.18)
        XCTAssertEqual(result.percentage(of: result.swift), 73.98)
        XCTAssertEqual(result.percentage(of: result.sumTotal), 100.00)
    }
}
