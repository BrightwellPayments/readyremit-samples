//
//  Constants.swift
//  ReadyRemitSDK
//
//  Created by Mohan Reddy on 07/10/21.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation


struct Constants {
  static var defaultFlag: String {  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4cL3I-Lg0JPr84eG2Ipms_tEAhB4sHbAMXQ&usqp=CAU" }
  static let usdIso3Code: String = "USD"
  static let usdSymbol: String = "$"
  static let rateDecimalPlaces: Int = 4
  static let sourceCurrencyDecimalPlaces: Int = 2
  static let dayMaxLength: Int = 2
  static let yearMaxLength: Int = 4
  static let maxPhoneNumberLength: Int = 11
  static let nameMaxLength: Int = 50
  static let ibanMaxLength: Int = 28
  static let bicMaxLength: Int = 11
  static let firstName: String = "FIRST_NAME"
  static let lastName: String = "LAST_NAME"
  static let phoneNumber: String = "PHONE_NUMBER"
  static let person: String = "PERSON"
  static let textType: String = "TEXT"
  static let numberType: String = "TEXT"
  static let bankAccountType: String = "BANK_ACCOUNT"
  static let bank: String = "BANK"
}

