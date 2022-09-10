//
//  BorderlessButton.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct BorderlessButtonModifier : ViewModifier, AppearanceConsumer {

  func body(content: Content) -> some View {
    content
      .font(font)
      .foregroundColor(color)
  }

  var font: Font {
    let spec = Self.appearance.borderlessButtonStyle.titleFont
    ?? Self.appearance.fonts.bodyEmphasis
    return .font(spec: spec, style: .body)
  }

  var color: Color {
    (Self.appearance.borderlessButtonStyle.titleFontColor
     ?? Self.appearance.colors.primaryShade1).color
  }
}
