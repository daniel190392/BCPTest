//
//  TransactionViewController.swift
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

protocol TransactionDisplayLogic: class {
    func displayCurrencyLoaded(viewModel: Transaction.CurrencyLoad.ViewModel)
    func displayAccountChanged(viewModel: Transaction.AmountChange.ViewModel)
}

class TransactionViewController: UIViewController, TransactionDisplayLogic {
    var interactor: TransactionBusinessLogic?
    var router: (NSObjectProtocol & TransactionRoutingLogic & TransactionDataPassing)?
    
    var transactionView = TransactionView()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = TransactionInteractor()
        let presenter = TransactionPresenter()
        let router = TransactionRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        view = transactionView
        transactionView.delegate = self
        loadNavigationBar(title: "", hideNavigation: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doLoadCurrencies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doLoadCurrencySelected()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doLoadCurrencies() {
        let request = Transaction.CurrencyLoad.Request()
        interactor?.doLoadCurrencies(request: request)
    }
    
    func doLoadCurrencySelected() {
        let request = Transaction.CurrencySelected.Request()
        interactor?.doLoadCurrencySelected(request: request)
    }
    
    func displayCurrencyLoaded(viewModel: Transaction.CurrencyLoad.ViewModel) {
        transactionView.setupView(viewModel: viewModel.transactionViewModel)
    }
    
    func displayAccountChanged(viewModel: Transaction.AmountChange.ViewModel) {
        transactionView.setCurrencyChanged(viewModel: viewModel)
    }
}

extension TransactionViewController: TransactionViewDelegate {
    func onAmountChange(amountValue: Double) {
        let request = Transaction.AmountChange.Request(amountValue: amountValue)
        interactor?.docChangeAmount(request: request)
    }
    
    func onCurrencyUpdate(option: Transaction.CurrencyChange.CurrencyOption) {
        let request = Transaction.CurrencyChange.Request(option: option)
        interactor?.doChangeCurrency(request: request)
        router?.routeToCurrenciesView()
    }
}
