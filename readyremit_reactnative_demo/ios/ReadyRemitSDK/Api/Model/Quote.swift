//
//  Quote.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation
import SwiftUI

struct TransferDetails: Codable, Hashable {
  var key: String
  var value: String
}


struct Quote : Decodable {
  let destinationCountryISO3Code: String
  let destinationCurrencyISO3Code: String
  let sendAmount: Amount
  let receiveAmount: Amount
  let rate: Decimal
  let adjustments: [Adjustment]
  let totalCost: Amount
  let disclosures: [Disclosure]
  let deliverySLA: DeliverySLA

  enum QuoteType: String {
    case sendAmount = "SEND_AMOUNT"
    case receiveAmount = "RECEIVE_AMOUNT"
  }
  
  func getRate() -> String {
    formatValue(value: rate, decimalPlaces: Constants.rateDecimalPlaces)
  }
  
  func getSendAmount() -> String {
    let amount = sendAmount.value / pow(10, Constants.sourceCurrencyDecimalPlaces)
    let formattedValue = formatValue(value: amount, decimalPlaces: Constants.sourceCurrencyDecimalPlaces)
    return formattedValue
  }
  
  func getReceiveAmount(decimalPlaces: Int) -> String {
    let amount = receiveAmount.value / pow(10, decimalPlaces)
    let formattedValue = formatValue(value: amount, decimalPlaces: Constants.sourceCurrencyDecimalPlaces)
    return formattedValue
  }
  
  func getTransferFee(decimalPlaces: Int = Constants.sourceCurrencyDecimalPlaces) -> String {
    if var fee = adjustments.first(where: { $0.label == "Transfer Fee" })?.amount.value {
      fee = fee / pow(10, decimalPlaces)
      return formatValue(value: fee, decimalPlaces: decimalPlaces)
    }
    return ""
  }
  
  func getTotalCost(decimalPlaces: Int = Constants.sourceCurrencyDecimalPlaces) -> String {
    let cost = totalCost.value / pow(10, decimalPlaces)
    return formatValue(value: cost, decimalPlaces: decimalPlaces)
  }
  
  func getDestinationCountry() -> String {
    let selection = Bundle.sdk.decodeJson([CountryCallingCode].self, from: "CountryCallingCodes")
    let callingCode = selection.filter{ $0.iso3Code == destinationCountryISO3Code }
    return callingCode[0].name
  }
  
  func getTransferDetails(transferData: [TransferDetails]) -> [TransferDetails] {
    var array = [
      TransferDetails(key: L10n.rrmRecipientNewDestinationCountry, value: self.getDestinationCountry()),
      TransferDetails(key: L10n.rrmTransferType, value: L10n.rrmBankTransfer),
      TransferDetails(key: L10n.rrmPreviewCostSent, value: "\(self.getSendAmount()) \(Constants.usdIso3Code)"),
      TransferDetails(key: L10n.rrmReceiveAmount, value: "\(self.getReceiveAmount(decimalPlaces: Constants.sourceCurrencyDecimalPlaces)) \(self.destinationCurrencyISO3Code)"),
      TransferDetails(key: L10n.rrmExchangeRate, value: "1 \(Constants.usdIso3Code) = \(self.rate) \(self.destinationCurrencyISO3Code)"),
      TransferDetails(key: L10n.rrmTransferFee, value: "\(self.getTransferFee()) \(Constants.usdIso3Code)"),
      TransferDetails(key: L10n.rrmTotalCost, value: "\(self.getTotalCost()) \(Constants.usdIso3Code)")
    ]
    array.append(contentsOf: transferData)
    
    return array
  }
  
  private func formatValue(value: Decimal, decimalPlaces: Int) -> String {

    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = decimalPlaces
    
    let formattedValue = formatter.string(from: value as NSNumber)
    return formattedValue ?? ""
  }
}


struct Disclosure: Decodable {
  let dummy: String
}

struct DeliverySLA: Decodable {
  let id: String
  let name: String
  
  static let mock = DeliverySLA(id: "MOCK_SLA", name: "Next Business Day")
}

#if DEBUG

extension Quote {
  static let mock = Quote(
    destinationCountryISO3Code: "IRL",
    destinationCurrencyISO3Code: "EUR",
    sendAmount: Amount(value: 7700, currency: Currency.mockSource),
                          receiveAmount: Amount(value: 6565, currency: Currency.mockDestination),
                          rate: 1,
                          adjustments: [],
                          totalCost: Amount(value: 7800, currency: Currency.mockSource),
                          disclosures: [],
                          deliverySLA: DeliverySLA.mock)
}

#endif
