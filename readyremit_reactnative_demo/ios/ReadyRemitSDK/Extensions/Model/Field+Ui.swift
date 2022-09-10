
//
//  Field+Ui.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


extension Field : Identifiable {}

extension Field : FieldReadonlyData {
  var name: String { label }
}

protocol FieldReadonlyData {
  var id: String { get }
  var name: String { get }
  var required: Bool { get }
  var placeholder: String { get }
  var info: String? { get }
  var group: String? { get }
  var textType: String? { get }
  var maxLength: Int? { get }
  var minLength: Int? { get }
  var options: [OptionsSet]? { get }
  var optionsSource: String? { get }
  var order: Int? { get }
}

extension FieldReadonlyData {
  var requiredPlaceholder: String {
    var text = required ? "* " : ""
    text.append(placeholder)
    return text
  }
}


enum ValidationResult : Equatable {
  case none, success, fail([String])
}

#if DEBUG
extension ValidationResult : Hashable {}
#endif


extension ValidationResult : AppearanceConsumer {

  var borderColor: Color {
    switch self {
    case .none:
      return Self.appearance.inputStyle.borderColorNormal?.color
      ?? Self.appearance.colors.controlShade2.color
    case .success:
      return Self.appearance.inputStyle.borderColorSuccess?.color
      ?? Self.appearance.colors.success.color
    case .fail:
      return Self.appearance.inputStyle.borderColorError?.color
      ?? Self.appearance.colors.error.color
    }
  }

  var labelTextColor: Color {
    switch self {
    case .success, .fail:
      return borderColor
    case .none:
      return Self.appearance.inputStyle.labelFontColor?.color
      ?? Self.appearance.colors.textPrimaryShade3.color
    }
  }
}
