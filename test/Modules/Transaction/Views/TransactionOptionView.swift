//
//  TransactionOptionView.swift
//  test
//
//  Created by Daniel Salhuana on 4/6/20.
//  Copyright © 2020 Daniel Salhuana. All rights reserved.
//

import UIKit

enum TransactionOptionType {
    case source
    case target
}

struct TransactionOptionViewModel {
    let optionType: TransactionOptionType
    let currencyValue: Double = 0.0
    let currencyName: String
    let symbol: String
    let delegate: TransactionOptionDelegate
}

protocol TransactionOptionDelegate {
    func onMoneyChange(option: TransactionOptionType, currencyValue: Double)
    func onClickButton(option: TransactionOptionType)
}

class TransactionOptionView: UIView {
    
    private var labelTitle = UILabel()
    private var textFieldMoney = UITextField()
    private var viewButton = UIView()
    private var labelButton = UILabel()
    
    var viewModel: TransactionOptionViewModel?
    var delegate: TransactionOptionDelegate?
    
    struct ViewTraits {
        static let mediumMargin: CGFloat = 16.0
        static let minMargin: CGFloat = 8.0
        static let labelSource: String = "Tu envias"
        static let labelTarget: String = "Tu recibes"
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
        labelTitle.textColor = .b_gray
        labelTitle.font = UIFont.regular12
        labelTitle.numberOfLines = 0
        addSubViewWithLayout(view: labelTitle)
        
        textFieldMoney.textColor = .black
        textFieldMoney.font = UIFont.regular12
        textFieldMoney.keyboardType = .decimalPad
        textFieldMoney.delegate = self
        addSubViewWithLayout(view: textFieldMoney)
        
        viewButton.clipsToBounds = true
        viewButton.backgroundColor = .black
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onButtonClick))
        viewButton.addGestureRecognizer(longPressGesture)
        addSubViewWithLayout(view: viewButton)
        
        labelButton.textColor = .b_white
        labelButton.font = UIFont.regular12
        viewButton.addSubViewWithLayout(view: labelButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewTraits.mediumMargin),
            labelTitle.topAnchor.constraint(equalTo: topAnchor, constant: ViewTraits.minMargin)
        ])
        
        NSLayoutConstraint.activate([
            textFieldMoney.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewTraits.mediumMargin),
            textFieldMoney.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: ViewTraits.minMargin),
            textFieldMoney.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ViewTraits.minMargin)
        ])
        
        NSLayoutConstraint.activate([
            viewButton.leadingAnchor.constraint(equalTo: labelTitle.trailingAnchor, constant: ViewTraits.mediumMargin),
            viewButton.leadingAnchor.constraint(equalTo: textFieldMoney.trailingAnchor, constant: ViewTraits.mediumMargin),
            viewButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewButton.topAnchor.constraint(equalTo: topAnchor),
            viewButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            labelButton.leadingAnchor.constraint(equalTo: viewButton.leadingAnchor, constant: ViewTraits.minMargin),
            labelButton.trailingAnchor.constraint(equalTo: viewButton.trailingAnchor, constant: -ViewTraits.minMargin),
            labelButton.centerYAnchor.constraint(equalTo: viewButton.centerYAnchor)
        ])
    }
    
    func setupView(viewModel: TransactionOptionViewModel) {
        self.viewModel = viewModel
        delegate = viewModel.delegate
        labelButton.text = viewModel.currencyName
        
        switch viewModel.optionType {
        case .source:
            labelTitle.text = ViewTraits.labelSource
            if let text = textFieldMoney.text, text.isEmpty {
                textFieldMoney.text = viewModel.currencyValue.getMoneyValue(symbol: viewModel.symbol)
            }
        case .target:
            labelTitle.text = ViewTraits.labelTarget
            textFieldMoney.isEnabled = false
            textFieldMoney.text = viewModel.currencyValue.getMoneyValue(symbol: viewModel.symbol)
        }
    }
    
    @objc private func onButtonClick() {
        guard let delegate = delegate, let viewModel = viewModel else {
            return
        }
        delegate.onClickButton(option: viewModel.optionType)
    }
}

extension TransactionOptionView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let viewModel = viewModel, let delegate = delegate, let textShowed = textField.text else {
            return false
        }
        
        var currencyValue = "\(textShowed) \(string)"
        currencyValue = currencyValue.replacingOccurrences(of: viewModel.symbol, with: "").trimmingCharacters(in: .whitespaces)
        if !currencyValue.isEmpty {
            delegate.onMoneyChange(option: viewModel.optionType, currencyValue: Double(currencyValue) ?? 0)
            return true
        }
        return false
    }
}
