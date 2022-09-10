//
//  Transfer.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/20/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation


class Transfer: Decodable {
  
  let transferId: String
  let confirmationNumber: String
  let createdAt: String?
  let dateAvailable: String?
  let quote: Quote
  let senderDetails: SenderDetails
  let recipientDetails: RecipientDetails
  let recipientAccountDetails: RecipientAccount
  let customer: Customer?
  let disclaimers: [String]
  
  enum CodingKeys: String, CodingKey {
    case transferId
    case confirmationNumber
    case createdAt
    case dateAvailable
    case quote
    case senderDetails
    case recipientDetails
    case recipientAccountDetails
    case customer
    case disclaimers
  }
  
  #if DEBUG
  static let mock = Transfer(transferId: "b708eb99-c06c-4d0b-9739-d603ae3ad7a4",
                             confirmationNumber: "33TF006977447",
                             createdAt: "",
                             dateAvailable: "",
                             quote: Quote.mock,
                             senderDetails: SenderDetails.mock,
                             recipientDetails: RecipientDetails.mock,
                             recipientAccountDetails: RecipientAccount.getRecipientAccountMock(),
                             customer: Customer.mock,
                             disclaimers: [])
  #endif
  
  init(transferId: String,
       confirmationNumber: String,
       createdAt: String,
       dateAvailable: String,
       quote: Quote,
       senderDetails: SenderDetails,
       recipientDetails: RecipientDetails,
       recipientAccountDetails: RecipientAccount,
       customer: Customer,
       disclaimers: [String]) {
    self.transferId = transferId
    self.confirmationNumber = confirmationNumber
    self.createdAt = createdAt
    self.dateAvailable = dateAvailable
    self.quote = quote
    self.senderDetails = senderDetails
    self.recipientDetails = recipientDetails
    self.recipientAccountDetails = recipientAccountDetails
    self.customer = customer
    self.disclaimers = disclaimers
  }
  
  func setTransferData() -> [TransferDetails] {
    let createdAt: String = self.createdAt!
    let index = createdAt.firstIndex(of: ".")
    let substr = createdAt.suffix(from: index!)
    let replacedStr = createdAt.replacingOccurrences(of: substr, with: "+00:00")
    
    let date = Date.getFormattedDate(string: replacedStr, formatter: "hh:mm | MM/dd/yyyy")
    let array = [
      TransferDetails(key: L10n.rrmConfirmationNumberTitle, value: self.confirmationNumber),
      TransferDetails(key: L10n.rrmTransferDateTitle, value: date),
      TransferDetails(key: L10n.rrmDateAvailableTitle, value: self.dateAvailable ?? "")
    ]
    return array
  }
  
  func setCustomerDetails() -> [CustomerDetails] {
    let array = [
      CustomerDetails(key: L10n.rrmCustomerDetailsName, value: self.customer?.name ?? ""),
      CustomerDetails(key: L10n.rrmCustomerDetailsAddressL1, value: self.customer?.addressLine1 ?? ""),
      CustomerDetails(key: L10n.rrmCustomerDetailsCity, value: self.customer?.addressCity ?? ""),
      CustomerDetails(key: L10n.rrmCustomerDetailsState, value: self.customer?.addressState ?? ""),
      CustomerDetails(key: L10n.rrmCustomerDetailsCountry, value: self.customer?.addressCountry ?? ""),
      CustomerDetails(key: L10n.rrmCustomerDetailsZip, value: self.customer?.addressZipCode ?? "")
    ]
    return array
  }
}

struct SenderDetails: Decodable {
  let fields: [AdditionalField]
  let senderId: String
  let senderType: String
  let companyName: String?
  
  static let mock = SenderDetails(fields: [],
                                  senderId: "123",
                                  senderType: "PERSON",
                                  companyName: "TEST_COMPANY")
}

struct RecipientDetails: Decodable {
  let fields: [AdditionalField]
  let senderId: String
  let recipientId: String
  let recipientType: String
  let firstName: String
  let lastName: String
  
  static let mock = RecipientDetails(fields: [],
                                     senderId: "123",
                                     recipientId: "123",
                                     recipientType: "PERSON",
                                     firstName: "Luc",
                                     lastName: "Jannsens")
}

struct CustomerDetails: Codable, Hashable {
  var key: String
  var value: String
}

struct Customer: Decodable {
  let name: String
  let addressLine1: String
  let addressCity: String
  let addressState: String
  let addressCountry: String
  let addressZipCode: String
  
  static let mock = Customer(
    name: "BWP shipping",
    addressLine1: "California",
    addressCity: "Los Angeles",
    addressState: "CA",
    addressCountry: "USA",
    addressZipCode: "150001")
}

