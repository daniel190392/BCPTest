//
//  TransactionInteractorTests.swift
//  test
//
//  Created by Daniel Salhuana on 4/7/20.
//  Copyright (c) 2020 Daniel Salhuana. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import test
import XCTest

class TransactionInteractorTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: TransactionInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupTransactionInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupTransactionInteractor() {
        sut = TransactionInteractor()
    }
    
    // MARK: Test doubles
    
    class TransactionPresentationLogicSpy: TransactionPresentationLogic {
        var presentErrorCalled = false
        var presentCurrenciesCalled = false
        var presentAccountChanged = false
        func presentLoaded(response: Transaction.CurrencyLoad.Response) {
            presentCurrenciesCalled = true
        }
        
        func presentAccountChanged(response: Transaction.AmountChange.Response) {
            presentAccountChanged = true
        }
        
        func presentErrorMessage(response: Transaction.Error.Response) {
            presentErrorCalled = true
        }
    }
    
    class MockTransactionWorker: TransactionWorker {
        enum responseTypes {
            case notLoad
            case emptyCurrency
            case noLocalCurrency
            case success
        }
        
        var type: responseTypes = .success
        init(type: responseTypes = .success) {
            self.type = type
        }
        
        override func doGetConversionRate (completionHandler:(Data?) -> Void) {
            var json = ""
            
            switch type {
            case .success:
               json = """
                    [
                        {
                            "currencyName": "Dolares",
                            "country": "EEUU",
                            "iso": "USD",
                            "symbol": "$",
                            "sellRate": 1,
                            "buyRate": 1
                        },
                        {
                            "currencyName": "Soles",
                            "country": "Peru",
                            "iso": "PEN",
                            "symbol": "S/",
                            "sellRate": 0.257088,
                            "buyRate": 0.297088
                        },
                        {
                            "currencyName": "EURO",
                            "country": "Union Europea",
                            "iso": "EUR",
                            "symbol": "€",
                            "sellRate": 1.08929,
                            "buyRate": 1.07929
                        },
                        {
                            "currencyName": "YEN",
                            "country": "JAPON",
                            "iso": "JPY",
                            "symbol": "¥",
                            "sellRate": 0.00859261,
                            "buyRate": 0.00919238
                        }
                    ]
                    """
                let responseData: Data? = json.data(using: .utf8)
                completionHandler(responseData)
            case .notLoad:
                completionHandler(nil)
            case .emptyCurrency:
                json = "[]"
                let responseData: Data? = json.data(using: .utf8)
                completionHandler(responseData)
            case .noLocalCurrency:
                json = """
                    [
                        {
                            "currencyName": "EURO",
                            "country": "Union Europea",
                            "iso": "EUR",
                            "symbol": "€",
                            "sellRate": 1.08929,
                            "buyRate": 1.07929
                        },
                        {
                            "currencyName": "YEN",
                            "country": "JAPON",
                            "iso": "JPY",
                            "symbol": "¥",
                            "sellRate": 0.00859261,
                            "buyRate": 0.00919238
                        }
                    ]
                    """
                let responseData: Data? = json.data(using: .utf8)
                completionHandler(responseData)
            }
        }
        
    }
    
    
    // MARK: Tests
    
    func testLoadCurrenciesWhenInteractorIsLoaded() {
        let spy = TransactionPresentationLogicSpy()
        sut?.presenter = spy
        sut?.worker = MockTransactionWorker()
        
        let request = Transaction.CurrencyLoad.Request()
        sut?.doLoadCurrencies(request:request)
        
        XCTAssertTrue(spy.presentCurrenciesCalled, "doLoadCurrencies(request:) should ask the presenter to format the result")
    }
    
    func testLoadCurrenciesWhenErrorIsLoaded() {
        let spy = TransactionPresentationLogicSpy()
        sut?.presenter = spy
        sut?.worker = MockTransactionWorker(type: .notLoad)
        
        let request = Transaction.CurrencyLoad.Request()
        sut?.doLoadCurrencies(request:request)
        
        XCTAssertTrue(spy.presentErrorCalled, "doLoadCurrencies(request:) should ask the presenter to format the result")
    }
    
    func testLoadCurrenciesWhenIsCorrect() {
        let spy = TransactionPresentationLogicSpy()
        sut?.presenter = spy
        sut?.worker = MockTransactionWorker()
        
        let request = Transaction.CurrencyLoad.Request()
        sut?.doLoadCurrencies(request:request)
        
        XCTAssertEqual(sut?.currencies.count, 4, "doGetConversionRate(request:) should get the the currencies list with 4 elements")
    }
    
    func testLoadCurrenciesWhenIsEmpty() {
        let spy = TransactionPresentationLogicSpy()
        sut?.presenter = spy
        sut?.worker = MockTransactionWorker(type: .emptyCurrency)
        
        let request = Transaction.CurrencyLoad.Request()
        sut?.doLoadCurrencies(request:request)
        
        XCTAssertEqual(sut?.currencies.count, 0, "doGetConversionRate(request:) should get the the currencies list with 0 elements")
    }
    
    func testLoadCurrenciesWhenDefaultsCurrenciesAreAussent() {
        let spy = TransactionPresentationLogicSpy()
        sut?.presenter = spy
        sut?.worker = MockTransactionWorker(type: .noLocalCurrency)
        
        let request = Transaction.CurrencyLoad.Request()
        sut?.doLoadCurrencies(request:request)
        
        XCTAssertTrue(spy.presentErrorCalled, "doLoadCurrencies(request:) should ask the presenter if called error when don't have defaults currencies")
    }
    
}
