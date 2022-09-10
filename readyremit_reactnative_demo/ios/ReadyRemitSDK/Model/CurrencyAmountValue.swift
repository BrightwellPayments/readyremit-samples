//
//  CurrencyAmountValue.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 3/16/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation


class CurrencyAmountValue: ObservableValue {
  override init () {}
  
  init(amount: String = "", currency: Currency, customErrorMessage: String = "") {
    self.amount = amount
    self.currency = currency
    self.customErrorMessage = customErrorMessage
  }
  
  @Published var currency: Currency? = nil

  @Published var amount: String = "" {
    willSet {
      if !didChange {
        didChange = amount != newValue
      }
    }
  }
  
  @Published var customErrorMessage: String = ""
  
  var decimalAmount: Decimal {
    Decimal(string: amount) ?? 0
  }
  
  func validate() -> ValidationResult {
    if decimalAmount <= 0 {
      return .fail([(self.customErrorMessage.isEmpty ? L10n.rrmErrorEmptyNumber : self.customErrorMessage)])
    }
    return .success
  }
}
