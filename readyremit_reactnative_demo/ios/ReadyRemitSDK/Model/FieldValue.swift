//
//  FieldValue.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation
import SwiftUI
import Combine


protocol AnyValue {
  var fieldReadonlyData: FieldReadonlyData { get }
  var validation: ValidationResult { get set }
}

typealias Value = AnyValue & Identifiable


class FieldValue<T>: ObservableObject, Value
where T: ObservableValue {
  let fieldReadonlyData: FieldReadonlyData
  let disabled: Bool
  @Published var value: T {
    didSet {
      if value.didChange, validation != .none {
        validation = .none
      }
      if oldValue !== value {
        value.didChange = false
      }
    }
  }

  init(field: FieldReadonlyData, disabled: Bool = false, value: T) {
    self.fieldReadonlyData = field
    self.disabled = disabled
    self.value = value
  }

  @Published var validation: ValidationResult = .none
}


class PickerFieldValue<T> : ObservableObject, Value
where T: Identifiable & Filterable & ListRowProvider {

  let fieldReadonlyData: FieldReadonlyData
  let disabled: Bool
  @Published var value: T?
  @Published var validation: ValidationResult = .none

  init(field: FieldReadonlyData, disabled: Bool = false, value: T?) {
    self.fieldReadonlyData = field
    self.disabled = disabled
    self.value = value
  }
}


class StringValue : ObservableObject, Value {
  enum StringValueType {
    case nameField, IBAN, BIC, generic, dynamic
  }
  
  let fieldReadonlyData: FieldReadonlyData
  let disabled: Bool
  let valueType: StringValueType
  let maxLength: Int
  let regex: String
  @Published var binding: Binding<String>?
  
  @Published var value: String {
    willSet {
      if newValue != value, validation != .none  {
        validation = .none
      }
    }
  }
  @Published var validation: ValidationResult
  
  init(
    field: FieldReadonlyData,
    disabled: Bool = false,
    value: String,
    validation: ValidationResult = .none,
    valueType: StringValueType,
    maxLength: Int = 0,
    regex: String = ""){
      self.fieldReadonlyData = field
      self.disabled = disabled
      self.value = value
      self.validation = validation
      self.valueType = valueType
      self.maxLength = maxLength
      self.regex = regex
  }
  
  func validate(_ minLength: Int = 0) {
    let count = value.count
    validation = value.isEmpty ? .fail([L10n.rrmErrorEmptyDynamicField(fieldReadonlyData.name)]) : ((count < minLength) ? .fail([L10n.rrmErrorMinlengthNumber(fieldReadonlyData.name, minLength)]) : .success)
  }
  
  func filterInput(_ input: String) -> String {
    switch valueType {
    case .nameField:
      return formatName(input)
    case .IBAN:
      return formatIBAN(input)
    case .BIC:
      return formatBIC(input)
    case .generic:
      return input
    case .dynamic:
      guard regex != "" else { return input }
      let regexValue: String = String(regex[..<(regex.range(of: "{")!.lowerBound)]).replacingOccurrences(of: "^", with: "")
      let matched = formatDynamic(input, regexValue)
      var result = ""
      matched.forEach { i in
        result += i
      }
      result = String(result.prefix(maxLength))
      return result
    }
  }
  
  func formatName(_ input: String) -> String {
    let allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ"
    var filtered = input.filter {
      allowed.contains($0)
    }.capitalizedFirstLetter()
    filtered = String(filtered.prefix(Constants.nameMaxLength))
    return filtered
  }
  
  func formatIBAN(_ input: String) -> String {
    return String(input.prefix(Constants.ibanMaxLength))
  }
  
  func formatBIC(_ input: String) -> String {
    return String(input.prefix(Constants.bicMaxLength))
  }
  
  func formatDynamic(_ input: String, _ regex: String) -> [String] {
    do{
      let pattern = try NSRegularExpression(pattern: regex)
      let result = pattern.matches(in: input, range: NSRange(input.startIndex..., in: input))
      return result.map {
        String(input[Range($0.range, in: input)!])
      }
    }catch {
      return []
    }
  }
}
