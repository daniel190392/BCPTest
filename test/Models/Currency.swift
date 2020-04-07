//
//  Currency.swift
//  test
//
//  Created by Daniel Salhuana on 4/7/20.
//  Copyright © 2020 Daniel Salhuana. All rights reserved.
//

import UIKit

struct Currency: Codable {
    var currencyName: String
    var country: String
    var iso: String
    var symbol: String
    var sellRate: Double
    var buyRate: Double
}
