//
//  Field.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


struct Field {
  let id: String
  let label: String
  let required: Bool
  let placeholder: String
  let info: String?
  var group: String? = ""
  var textType: String? = ""
  var minLength: Int? = 0
  var maxLength: Int? = 0
  var options: [OptionsSet]?
  var optionsSource: String? = ""
  var order: Int? = 0
}

extension Field {
  enum type : String {
    case text = "TEXT"
  }
}
