//
//  Currency.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation
import SwiftUI


struct Currency : Decodable, Equatable {
  let name: String
  let iso3Code: String
  let symbol: String
  let decimalPlaces: Int
}

extension Currency {

  static let numbersString = "0123456789"

  func allowedCharactersString(inLocale locale: Locale = .current) -> String {
    var allowed = Self.numbersString

    if let separator = locale.decimalSeparator {
      allowed.append(separator)
    }
    return allowed
  }

  func cleanupInputString(_ input: String,
                          inLocale locale: Locale = .current) -> String {
    let allowed = allowedCharactersString(inLocale: locale)
    // Ensure it only contains numbers and (possibly) decimal separator
    var cleaned = input.filter {
      allowed.contains($0)
    }
    // Remove leading zeros
    while cleaned.hasPrefix("0") {
      cleaned.remove(at: cleaned.startIndex)
    }
    // If there are more than 1 decimal separator, remove from end until it's 1 (max)
    if let decimalString = locale.decimalSeparator,
       let decimalChar = decimalString.last {
      while cleaned.filter({ decimalString.contains($0) }).count > 1,
            let decimalIndex = cleaned.lastIndex(of: decimalChar) {
        cleaned.remove(at: decimalIndex)
      }
      // Remove decimal places above self.decimalPlaces
      if let i = cleaned.lastIndex(of: decimalChar) {
        while cleaned[i..<cleaned.endIndex].count > decimalPlaces + 1 {
          cleaned.removeLast()
        }
      }
      if decimalPlaces <= 0,
         cleaned.hasSuffix(decimalString) {
        cleaned.removeLast()
      }
    }
    return cleaned
  }
}

//MARK: - Currency + DropDownList

extension Currency : Identifiable {

  var id: String { iso3Code }
}


extension Currency : Filterable {

  func matches(lowercasedFilter: String) -> Bool {
    name.lowercased().contains(lowercasedFilter)
    || iso3Code.lowercased().contains(lowercasedFilter)
  }
}


extension Currency : ListRowProvider {

  @ViewBuilder func row() -> some View {
    HStack(spacing: 16) {
      FlagView(flagImage: FlagImage(currencyIso3Code: iso3Code))
      Text(iso3Code)
      Text(name)
      Spacer()
    }
  }
}

#if DEBUG

extension Currency {
  static let mockSource = Currency(name: "US Dollar", iso3Code: "USD", symbol: "$", decimalPlaces: 2)
  static let mockDestination = Currency(name: "Euro", iso3Code: "EUR", symbol: "\\u20ac", decimalPlaces: 2)
}

#endif
