//
//  Recipient.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation

struct RecipientResponse: Codable {
  let recipients: [RecipientData]
}

struct RecipientData: Codable {
  let recipientId: String?
  let senderId: String?
  let firstName: String?
  let lastName: String?
  let recipientAccounts: [RecipientAccounts]
}

struct RecipientAccounts: Codable {
  let dstCurrencyIso3Code: String?
  let dstCountryIso3Code: String?
  let transferMethod: String?
  let recipientAccountId: String?
  let accountNumber: String?
  let fields: [Fields]
}

struct Fields: Codable {
  let id: String?
  let type: String?
  let name: String?
  let value: String?
}

struct Recipient: Codable {
  let id: Int
  let name: String
  let countryIsoCode: String
  let fxRate: String?
  let flag: String?
}
