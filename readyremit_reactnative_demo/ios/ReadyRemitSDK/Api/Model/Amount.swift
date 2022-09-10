//
//  Amount.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


struct Amount : Decodable {
  let value: Decimal
  let currency: Currency
}


struct Money : Decodable {
  let units: Int
  let currency: Currency
}


struct Adjustment : Decodable {
  let label: String
  let amount: Amount
}


struct Limit : Decodable {
  let message: String
  let money: Money
}
