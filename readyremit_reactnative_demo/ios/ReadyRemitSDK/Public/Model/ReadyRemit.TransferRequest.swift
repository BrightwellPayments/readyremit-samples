//
//  ReadyRemit.TransferRequest.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/17/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation


extension ReadyRemit {
  
  @objc
  public class TransferRequest: NSObject, Codable {
    
    let dstCountryIso3Code: String
    let dstCurrencyIso3Code: String
    let srcCurrencyIso3Code: String
    let transferMethod: String
    let quoteBy: String
    public let amount: Int
    let fee: String
    let senderId: String
    let recipientId: String
    let recipientAccountId: String
    let purposeOfRemittance: String
    
    internal init(dstCountryIso3Code: String,
                  dstCurrencyIso3Code: String,
                  srcCurrencyIso3Code: String,
                  transferMethod: String,
                  quoteBy: String,
                  amount: Int,
                  fee: String,
                  senderId: String,
                  recipientId: String,
                  recipientAccountId: String,
                  purposeOfRemittance: String) {
      self.dstCountryIso3Code = dstCountryIso3Code
      self.dstCurrencyIso3Code = dstCurrencyIso3Code
      self.srcCurrencyIso3Code = srcCurrencyIso3Code
      self.transferMethod = transferMethod
      self.quoteBy = quoteBy
      self.amount = amount
      self.fee = fee
      self.senderId = senderId
      self.recipientId = recipientId
      self.recipientAccountId = recipientAccountId
      self.purposeOfRemittance = purposeOfRemittance
    }
  }
}
