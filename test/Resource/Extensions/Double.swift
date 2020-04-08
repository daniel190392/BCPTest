//
//  Double.swift
//  test
//
//  Created by Daniel Salhuana on 4/7/20.
//  Copyright © 2020 Daniel Salhuana. All rights reserved.
//

import UIKit

extension Double {
    func getMoneyValue(symbol: String  = "") -> String {
        let currencyFormatter = Double.getNumberFormatter()
//        currencyFormatter.numberStyle = .currency
//        currencyFormatter.currencySymbol = symbol
        return currencyFormatter.string(from: NSNumber(value: self))!
    }
    
    static func getNumberFormatter() -> NumberFormatter {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.minimumFractionDigits = 3
        currencyFormatter.maximumFractionDigits = 3
        return currencyFormatter
    }
}
