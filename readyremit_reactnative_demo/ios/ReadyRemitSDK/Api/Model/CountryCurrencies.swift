//
//  CountryCurrencies.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


struct CountryCurrencies : Decodable {
  let country: Country
  let currencies: [Currency]
}


extension CountryCurrencies : Identifiable {
  var id: String { country.iso3Code }
}


extension CountryCurrencies : Hashable {

  func hash(into hasher: inout Hasher) {
    hasher.combine(country.iso3Code)
  }
}


extension CountryCurrencies : Equatable {

  static func ==(lhs: CountryCurrencies, rhs: CountryCurrencies) -> Bool {
    lhs.country.iso3Code == rhs.country.iso3Code
  }
}
