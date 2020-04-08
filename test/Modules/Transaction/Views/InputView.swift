//
//  TransactionOptionView.swift
//  test
//
//  Created by Daniel Salhuana on 4/6/20.
//  Copyright © 2020 Daniel Salhuana. All rights reserved.
//

import UIKit

struct InputViewModel {
    let optionType: Transaction.CurrencyChange.CurrencyOption
    let currencyValue: Double = 0
    let currencyName: String
    let symbol: String
}

protocol TransactionOptionDelegate: class {
    func onAmountChange(amountValue: Double)
    func onCurrencyUpdate(option: Transaction.CurrencyChange.CurrencyOption)
    func onKeyboardSizeChange(keyboardheight: CGFloat)
}

class InputView: UIView {
    
    private var labelTitle = UILabel()
    private var textFieldAmount = UITextField()
    private var viewButton = UIView()
    private var labelButton = UILabel()
    
    var viewModel: InputViewModel?
    weak var delegate: TransactionOptionDelegate?
    
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
    
    deinit {
        if let viewModel = viewModel, viewModel.optionType == .source {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    private func setupComponents() {
        labelTitle.textColor = .b_gray
        labelTitle.font = UIFont.regular12
        labelTitle.numberOfLines = 0
        addSubViewWithLayout(view: labelTitle)
        
        textFieldAmount.textColor = .black
        textFieldAmount.font = UIFont.regular12
        textFieldAmount.keyboardType = .decimalPad
        textFieldAmount.delegate = self
        addSubViewWithLayout(view: textFieldAmount)
        
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
            textFieldAmount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewTraits.mediumMargin),
            textFieldAmount.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: ViewTraits.minMargin),
            textFieldAmount.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ViewTraits.minMargin)
        ])
        
        NSLayoutConstraint.activate([
            viewButton.leadingAnchor.constraint(equalTo: labelTitle.trailingAnchor, constant: ViewTraits.mediumMargin),
            viewButton.leadingAnchor.constraint(equalTo: textFieldAmount.trailingAnchor, constant: ViewTraits.mediumMargin),
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
    
    func setupView(viewModel: InputViewModel) {
        self.viewModel = viewModel
        labelButton.text = viewModel.currencyName.uppercased()
        
        switch viewModel.optionType {
        case .source:
            labelTitle.text = ViewTraits.labelSource
            textFieldAmount.text = viewModel.currencyValue.getMoneyValue()
            enabledNotificationCenter()
        case .target:
            labelTitle.text = ViewTraits.labelTarget
            textFieldAmount.isEnabled = false
            textFieldAmount.text = viewModel.currencyValue.getMoneyValue(symbol: viewModel.symbol)
        }
    }
    
    func updateCurrencyValue(currencyValue: String) {
        textFieldAmount.text = currencyValue
    }
    
    func resigTextFieldResponder() {
        textFieldAmount.resignFirstResponder()
    }
    
    private func enabledNotificationCenter() {
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.keyboardNotification(notification:)),
        name: UIResponder.keyboardWillShowNotification,
        object: nil)
    }
    
    @objc private func onButtonClick(sender: UILongPressGestureRecognizer) {
        guard let delegate = delegate, let viewModel = viewModel, sender.state == .began else {
            return
        }
        delegate.onCurrencyUpdate(option: viewModel.optionType)
    }
    
    @objc private func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo, let delegate = delegate else {
            return
        }
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        delegate.onKeyboardSizeChange(keyboardheight: endFrame?.size.height ?? 0)
    }
    
    func getCurrencyValue(symbol: String) -> Double {
        guard let currencyValue = textFieldAmount.text else {
            return 0
        }
        let value = currencyValue.replacingOccurrences(of: symbol, with: "").trimmingCharacters(in: .whitespaces)
        return Double(value) ?? 0
    }
}

extension InputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let viewModel = viewModel, let delegate = delegate, let text = textField.text,
        let textRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        let currencyValue = updatedText.replacingOccurrences(of: viewModel.symbol, with: "").trimmingCharacters(in: .whitespaces)
        if Double.getNumberFormatter().number(from: updatedText) != nil || updatedText.isEmpty {
            delegate.onAmountChange(amountValue: Double(currencyValue) ?? 0)
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var stringAmount = "0.000"
        if textField.text?.isEmpty != true {
            stringAmount = (Double(textField.text ?? "0") ?? 0).getMoneyValue()
        }
        textField.text = stringAmount
    }
}
