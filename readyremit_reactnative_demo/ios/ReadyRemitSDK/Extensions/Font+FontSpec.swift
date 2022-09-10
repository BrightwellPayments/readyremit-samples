//
//  Font+FontSpec.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


extension Font {

  typealias FontSpec = ReadyRemit.FontSpec

  static func font(spec: FontSpec?, style: TextStyle) -> Font {
    let fontName = spec?.family ?? FontSpec.defaultFamily
    let fontSize = spec?.size ?? style.baseFontSize

    var font: Font

    switch (fontName, FontSpec.dynamicFontsize) {

    case (.some(let name), true):
      if #available(iOS 14, *) {
        font = Font.custom(name, size: fontSize, relativeTo: style)
      } else {
        font = Font.custom(name, size: fontSize)
      }

    case (.some(let name), false):
      if #available(iOS 14, *) {
        font = Font.custom(name, fixedSize: fontSize)
      } else {
        if let uifont = UIFont(name: name, size: fontSize) {
          font = Font(uifont)
        } else {
          font = Font(UIFont.systemFont(ofSize: fontSize))
        }
      }

    case (.none, true):
      font = style.font

    case (.none, false):
      font = Font(UIFont.systemFont(ofSize: fontSize))
    }

    if let weight = spec?.weight {
      font = font.weight(weight.fontWeight)
    }
    if spec?.italic == true {
      font = font.italic()
    }
    return font
  }
}
