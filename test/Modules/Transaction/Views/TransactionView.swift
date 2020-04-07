//
//  TransactionView.swift
//  test
//
//  Created by Daniel Salhuana on 4/6/20.
//  Copyright © 2020 Daniel Salhuana. All rights reserved.
//

import UIKit

protocol TransactionViewDelegate {
    func onMoneyChange(option: TransactionOptionType, currencyValue: Double)
    func onClickButton(option: TransactionOptionType)
}

class TransactionView: UIView {

    private var imageViewLogo = UIImageView()
    private var borderView = UIView()
    private var stackView = UIStackView()
    private var sourceCurrency = TransactionOptionView()
    private var targetCurrency = TransactionOptionView()
    private var separatorView = UIView()
    private var labelChange = UILabel()
    private var buttonTransaction = UIButton()
    
    var delegate: TransactionViewDelegate?
    
    struct ViewTraits {
        static let horizontalMargin: CGFloat = 20.0
        static let verticalMargin: CGFloat = 20.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupComponents()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents() {
        backgroundColor = .white
        
        imageViewLogo.image = UIImage(named: "BCP")
        imageViewLogo.contentMode = .scaleAspectFit
        addSubViewWithLayout(view: imageViewLogo)
        
        borderView.backgroundColor = .b_white
        borderView.layer.cornerRadius = 5
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.b_gray.cgColor
        borderView.clipsToBounds = true
        addSubViewWithLayout(view: borderView)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        borderView.addSubViewWithLayout(view: stackView)
        
        stackView.addArrangedSubview(sourceCurrency)
        stackView.addArrangedSubview(targetCurrency)
        
        separatorView.backgroundColor = .b_gray
        borderView.addSubViewWithLayout(view: separatorView)
        
        
        labelChange.textAlignment = .center
        labelChange.font = UIFont.regular16
        addSubViewWithLayout(view: labelChange)
        
        buttonTransaction.setTitleColor(.b_white, for: .normal)
        buttonTransaction.backgroundColor = .b_darkBlue
        buttonTransaction.setTitle("Empieza tu operacion", for: .normal)
        addSubViewWithLayout(view: buttonTransaction)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageViewLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageViewLogo.topAnchor.constraint(equalTo: topAnchor, constant: ViewTraits.verticalMargin),
            imageViewLogo.widthAnchor.constraint(equalToConstant: 200),
            imageViewLogo.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            borderView.topAnchor.constraint(equalTo: imageViewLogo.bottomAnchor, constant: ViewTraits.verticalMargin)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: borderView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor),
            separatorView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            labelChange.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelChange.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            labelChange.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 24),
        ])
        
        NSLayoutConstraint.activate([
            buttonTransaction.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonTransaction.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonTransaction.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonTransaction.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupView(viewModel: Transaction.CurrencyLoad.ViewModel) {
        let optionOne = TransactionOptionViewModel(optionType: .source, currencyName: viewModel.sourceName, symbol: viewModel.sourceSymbol, delegate: self)
        let optionTwo = TransactionOptionViewModel(optionType: .target, currencyName: viewModel.targetName, symbol: viewModel.targetSymbol, delegate: self)
        sourceCurrency.setupView(viewModel: optionOne)
        targetCurrency.setupView(viewModel: optionTwo)
        labelChange.text = "Compra: \(viewModel.buyRate) | Venta: \(viewModel.sellRate)"
    }
}

extension TransactionView: TransactionOptionDelegate {
    func onMoneyChange(option: TransactionOptionType, currencyValue: Double) {
        guard let delegate = delegate else {
            return
        }
        delegate.onMoneyChange(option: option, currencyValue: currencyValue)
    }
    
    func onClickButton(option: TransactionOptionType) {
        guard let delegate = delegate else {
            return
        }
        delegate.onClickButton(option: option)
    }
}
