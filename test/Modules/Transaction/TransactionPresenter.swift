//
//  TransactionPresenter.swift
//  test
//
//  Created by Daniel Salhuana on 4/6/20.
//  Copyright (c) 2020 Daniel Salhuana. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TransactionPresentationLogic {
    func presentLoaded(response: Transaction.CurrencyLoad.Response)
    func presentAccountChanged(response: Transaction.AmountChange.Response)
    func presentErrorMessage(response: Transaction.Error.Response)
}

class TransactionPresenter: TransactionPresentationLogic {
    weak var viewController: TransactionDisplayLogic?
    
    func presentLoaded(response: Transaction.CurrencyLoad.Response) {
        let source = response.source
        let target = response.target
        let sourceInput = InputViewModel(optionType: .source, currencyName: source.currencyName, symbol: source.symbol)
        let targetInput = InputViewModel(optionType: .target, currencyName: target.currencyName, symbol: target.symbol)
        let currentRate = "Compra: \(source.symbol) \(response.buyRate.getMoneyValue()) | Venta: \(source.symbol) \(response.sellRate.getMoneyValue())"
        
        let transactionViewModel = TransactionViewModel(sourceInput: sourceInput, targetInput: targetInput, currentRate: currentRate)
        let viewModel = Transaction.CurrencyLoad.ViewModel(transactionViewModel: transactionViewModel)
        viewController?.displayCurrencyLoaded(viewModel: viewModel)
    }
    
    func presentAccountChanged(response: Transaction.AmountChange.Response) {
        let viewModel = Transaction.AmountChange.ViewModel(amountChanged: response.amountChanged.getMoneyValue())
        viewController?.displayAccountChanged(viewModel: viewModel)
    }
    
    func presentErrorMessage(response: Transaction.Error.Response) {
        var message = ""
        switch response.errorType {
        case .notLoad:
            message = "Sorry, we have problem with the currencies information, we are working to fix that"
        case .emptyCurrency:
            message = "Sorry, we don't have the information completed, you can try again?"
        case .noLocalCurrency:
            message = "Sorry for the problem, we are experimenting some issues"
        }
        let viewModel = Transaction.Error.ViewModel(message: message)
        viewController?.displayErrorView(viewModel: viewModel)
    }
}
