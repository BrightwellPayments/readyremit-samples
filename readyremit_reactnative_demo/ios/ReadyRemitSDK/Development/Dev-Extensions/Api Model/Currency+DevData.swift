//
//  Currency+DevData.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import Foundation


extension Currency {

  static let currencies = [
    Currency(name: "Norwegian krone", iso3Code: "NOK", symbol: "kr", decimalPlaces: 2),
    Currency(name: "US dollar", iso3Code: "USD", symbol: "$", decimalPlaces: 2),
    Currency(name: "Philippine peso", iso3Code: "PHP", symbol: "₱", decimalPlaces: 2),
    Currency(name: "Euro", iso3Code: "EUR", symbol: "€", decimalPlaces: 2),
    Currency(name: "Japanese yen", iso3Code: "JPY", symbol: "¥", decimalPlaces: 2),
    Currency(name: "Indonesian rupiah", iso3Code: "IDR", symbol: "Rp", decimalPlaces: 2),
    Currency(name: "Mauritian rupee", iso3Code: "MUR", symbol: "₨", decimalPlaces: 2),
    Currency(name: "Zimdollar", iso3Code: "ZWL", symbol: "ZWL$", decimalPlaces: 2),
    Currency(name: "Pound sterling", iso3Code: "GBP", symbol: "£", decimalPlaces: 2),
    Currency(name: "Russian ruble", iso3Code: "RUB", symbol: "₽", decimalPlaces: 2),
    Currency(name: "New Zealand dollar", iso3Code: "NZD", symbol: "$", decimalPlaces: 2),
  ]
}

#endif
