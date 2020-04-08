//
//  DoubleExtensionTests.swift
//  testTests
//
//  Created by Daniel Salhuana on 4/8/20.
//  Copyright © 2020 Daniel Salhuana. All rights reserved.
//
@testable import test
import XCTest

class DoubleExtensionTests: XCTestCase {
    
    func testParseRoundingAmount() {
        let amount: Double = 532434.344642340
        let stringAmount = amount.getMoneyValue()
        let expectedAmount = "532434.345"
        XCTAssertEqual(stringAmount, expectedAmount, "value \(stringAmount) is not equal to \(expectedAmount)")
    }
    
    func testParseLittleAmount() {
        let amount: Double = 5.0
        let stringAmount = amount.getMoneyValue()
        let expectedAmount = "5.000"
        XCTAssertEqual(stringAmount, expectedAmount, "value \(stringAmount) is not equal to \(expectedAmount)")
    }
    
    func testParseAmountWithoutDecimal() {
        let amount: Double = 5
        let stringAmount = amount.getMoneyValue()
        let expectedAmount = "5.000"
        XCTAssertEqual(stringAmount, expectedAmount, "value \(stringAmount) is not equal to \(expectedAmount)")
    }
    
    func testParseAmountWithFewDecimals() {
        let amount: Double = 5.1
        let stringAmount = amount.getMoneyValue()
        let expectedAmount = "5.100"
        XCTAssertEqual(stringAmount, expectedAmount, "value \(stringAmount) is not equal to \(expectedAmount)")
    }
    
    func testParseAmountWithLotsOfDecimals() {
        let amount: Double = 5.8888333330
        let stringAmount = amount.getMoneyValue()
        let expectedAmount = "5.889"
        XCTAssertEqual(stringAmount, expectedAmount, "value \(stringAmount) is not equal to \(expectedAmount)")
    }
    
}
