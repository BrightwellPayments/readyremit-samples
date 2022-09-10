//
//  SheetButton.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI

///
/// Button like on a UIAlertSheet:
/// Claims all horizontal space
/// Changes appearance depending on Context
///
struct CallforactionButtonStyle: ButtonStyle {

  enum Context {
    case primary, secondary, borderless
  }

  var context: Context = .primary
  var disabled: Bool = false

  public func makeBody(configuration: CallforactionButtonStyle.Configuration) -> some View {
    configuration.label
      .font(titleFont)
      .frame(maxWidth: .infinity)
      .foregroundColor(titleColor(pressed: configuration.isPressed))
      .padding()
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(borderColor(pressed: configuration.isPressed), lineWidth: borderWidth)
      )
      .background(
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(fillColor(pressed: configuration.isPressed))
      )
      .padding(.horizontal, 16)
      .compositingGroup()
  }
}


extension CallforactionButtonStyle: AppearanceConsumer {

  var titleFont: Font {
    let spec: ReadyRemit.FontSpec?
    switch context {
    case .primary:
      spec = Self.appearance.primaryButtonStyle.titleFont
    case .secondary:
      spec = Self.appearance.secondaryButtonStyle.titleFont
    case .borderless:
      spec = Self.appearance.borderlessButtonStyle.titleFont
    }
    return .font(spec: spec ?? Self.appearance.fonts.bodyEmphasis, style: .body)
  }

  func titleColor(pressed: Bool) -> Color {
    switch (context, disabled, pressed) {
    case (.primary, true, _):
      return Self.appearance.primaryButtonStyle.titleFontColorDisabled?.color
      ?? Self.appearance.colors.textPrimaryShade1.color
    case (.primary, _, false):
      return Self.appearance.primaryButtonStyle.titleFontColor?.color
      ?? Self.appearance.colors.textPrimaryShade5.color
    case (.primary, _, true):
      return Self.appearance.primaryButtonStyle.titleFontColorPressed?.color
      ?? Self.appearance.colors.textPrimaryShade5.color

    case (.secondary, true, _):
      return Self.appearance.secondaryButtonStyle.titleFontColorDisabled?.color
      ?? Self.appearance.colors.secondaryShade3.color
    case (.secondary, _, false):
      return Self.appearance.secondaryButtonStyle.titleFontColor?.color
      ?? Self.appearance.colors.textPrimaryShade4.color
    case (.secondary, _, true):
      return Self.appearance.secondaryButtonStyle.titleFontColorPressed?.color
      ?? Self.appearance.colors.textPrimaryShade1.color
      
    case (.borderless, true, _):
      return Self.appearance.borderlessButtonStyle.titleFontColorDisabled?.color
      ?? Self.appearance.colors.textPrimaryDisabled.color
    case (.borderless, _, false):
      return Self.appearance.borderlessButtonStyle.titleFontColor?.color
      ?? Self.appearance.colors.primaryShade1.color
    case (.borderless, _, true):
      return Self.appearance.borderlessButtonStyle.titleFontColorPressed?.color
      ?? Self.appearance.colors.primaryShade1.color
    }
  }

  func fillColor(pressed: Bool) -> Color {
    switch (context, disabled, pressed) {
    case (.primary, true, _):
      return Self.appearance.primaryButtonStyle.backgroundColorDisabled?.color
      ?? Self.appearance.colors.secondaryShade2.color
    case (.primary, _, false):
      return Self.appearance.primaryButtonStyle.backgroundColor?.color
      ?? Self.appearance.colors.primaryShade1.color
    case (.primary, _, true):
      return Self.appearance.primaryButtonStyle.backgroundColorPressed?.color
      ?? Self.appearance.colors.primaryShade2.color

    case (.secondary, true, _):
      return Self.appearance.secondaryButtonStyle.backgroundColorDisabled?.color
      ?? Color.tappable
    case (.secondary, _, false):
      return Self.appearance.secondaryButtonStyle.backgroundColor?.color
      ?? Color.tappable
    case (.secondary, _, true):
      return Self.appearance.secondaryButtonStyle.backgroundColorPressed?.color
      ?? Self.appearance.colors.secondaryShade1.color
      
    case (.borderless, _, _):
      return Color.clear
    }
  }

  func borderColor(pressed: Bool) -> Color {
    switch (context, disabled, pressed) {
    case (.primary, true, _):
      return Self.appearance.primaryButtonStyle.borderColorDisabled?.color
      ?? fillColor(pressed: pressed)
    case (.primary, _, false):
      return Self.appearance.primaryButtonStyle.borderColor?.color
      ?? fillColor(pressed: pressed)
    case (.primary, _, true):
      return Self.appearance.primaryButtonStyle.borderColorPressed?.color
      ?? fillColor(pressed: pressed)

    case (.secondary, true, _):
      return Self.appearance.secondaryButtonStyle.borderColorDisabled?.color
      ?? Self.appearance.colors.secondaryShade3.color
    case (.secondary, _, false):
      return Self.appearance.secondaryButtonStyle.borderColor?.color
      ?? Self.appearance.colors.secondaryShade3.color
    case (.secondary, _, true):
      return Self.appearance.secondaryButtonStyle.borderColorPressed?.color
      ?? Self.appearance.colors.secondaryShade3.color
      
    case (.borderless, _, _):
      return Color.clear
    }
  }

  var borderWidth: CGFloat {
    switch context {
    case .primary:
      return Self.appearance.primaryButtonStyle.borderWidth ?? 1
    case .secondary:
      return Self.appearance.secondaryButtonStyle.borderWidth ?? 1
    case .borderless:
      return 0
    }
  }

  var cornerRadius: CGFloat {
    switch context {
    case .primary:
      return Self.appearance.primaryButtonStyle.borderCornerRadius ?? 2
    case .secondary:
      return Self.appearance.secondaryButtonStyle.borderCornerRadius ?? 2
    case .borderless:
      return 0
    }
  }
}


struct CallforactionButton_previews: PreviewProvider {

  static var previews: some View {
    VStack(spacing: 20) {
      Button("Primary") {}
      .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))

      Button("Primary disabled") {}
      .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: true))

      Button("Secondary") {}
      .buttonStyle(CallforactionButtonStyle(context: .secondary, disabled: false))

      Button("Secondary disabled") {}
      .buttonStyle(CallforactionButtonStyle(context: .secondary, disabled: true))
      
      Button("Borderless") {}
      .buttonStyle(CallforactionButtonStyle(context: .borderless, disabled: false))

      Button("Borderless disabled") {}
      .buttonStyle(CallforactionButtonStyle(context: .borderless, disabled: true))
    }
    .previewLayout(.fixed(width: 200, height: 60))
  }
}
