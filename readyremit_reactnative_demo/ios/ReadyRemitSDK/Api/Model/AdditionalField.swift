//
//  AdditionalField.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/10/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation

struct AdditionalField: Identifiable, Codable {
  let type: String
  let id: String
  let name: String?
  let value: DynamicFieldValue
}

struct PhoneNumber: Codable {
  let countryIso3Code: String
  let countryPhoneCode: Int
  let number: String
}

enum DynamicFieldValue: Codable {
  case string(String)
  case int(Int)
  case phoneNumber(PhoneNumber)
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    
    if let value = try? container.decode(String.self) {
      self = .string(value)
      return
    }
    
    if let value = try? container.decode(Int.self) {
      self = .int(value)
      return
    }
    
    if let phone = try? container.decode(PhoneNumber.self) {
      self = .phoneNumber(phone)
      return
    }
    
    throw DynamicFieldError.missingValue
  }
  
  init(value: String) {
    self = .string(value)
  }
  
  init(value: Int) {
    self = .int(value)
  }
  
  init(value: PhoneNumber) {
    self = .phoneNumber(value)
  }
  
  enum DynamicFieldError:Error {
    case missingValue
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .string(let string):
      try container.encode(string)
    case .int(let int):
      try container.encode(int)
    case .phoneNumber(let phoneNumber):
      try container.encode(phoneNumber)
    }
  }
  
  var getValue : Any {
    switch self {
    case .int(let value): return Int(value)
    case .string(let value): return String(value)
    case .phoneNumber(let value): return value as PhoneNumber
    }
  }
}
