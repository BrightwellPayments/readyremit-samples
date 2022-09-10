//
//  Color+Fallback.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI

extension UIColor {

  struct Palette {

    static let clear = UIColor(lightHex: "#FFFFFF00", darkHex: "#FFFFFF00")
    static var white = UIColor(lightHex: "#FFFFFF", darkHex: "#FFFFFF")

    static let primary500 = UIColor(lightHex: "#3B73ED", darkHex: "#567FDA")
    static let primary600 = UIColor(lightHex: "#2563EB", darkHex: "#4371D6")
    static let primary700 = UIColor(lightHex: "#1E4FBC", darkHex: "#365AAB")
    static var primary800 = UIColor(lightHex: "#163B8D", darkHex: "#284480")

    static let gray0 = UIColor(lightHex: "#FFFFFF", darkHex: "#0C101B")
    static let gray50 = UIColor(lightHex: "#F9FAFB", darkHex: "#111827")
    static let gray100 = UIColor(lightHex: "#F3F4F6", darkHex: "#1F2937")
    static let gray200 = UIColor(lightHex: "#E5E7EB", darkHex: "#374151")
    static let gray300 = UIColor(lightHex: "#D1D5DB", darkHex: "#4B5563")
    static let gray400 = UIColor(lightHex: "#9CA3AF", darkHex: "#6B7280")
    static let gray500 = UIColor(lightHex: "#6B7280", darkHex: "#9CA3AF")
    static let gray600 = UIColor(lightHex: "#4B5563", darkHex: "#D1D5DB")
    static let gray700 = UIColor(lightHex: "#374151", darkHex: "#E5E7EB")
    static let gray800 = UIColor(lightHex: "#1F2937", darkHex: "#F3F4F6")
    static let gray900 = UIColor(lightHex: "#111827", darkHex: "#F9FAFB")
    static let gray1000 = UIColor(lightHex: "#0C101B", darkHex: "#FFFFFF")

    static let success600 = UIColor(lightHex: "#008761", darkHex: "#19AA81")
    
    static let error50 = UIColor(lightHex: "#FCE9E9", darkHex: "#FBECEC")
    static let error600 = UIColor(lightHex: "#DC2626", darkHex: "#D53F3F")
    static let error1000 = UIColor(lightHex: "#2C0808", darkHex: "#2B0D0D")
  }


  struct Fallback {

    static var primaryShade1: UIColor = Palette.primary700
    static var primaryShade2: UIColor = Palette.primary600
    static var secondaryShade1: UIColor = Palette.gray100
    static var secondaryShade2: UIColor = Palette.gray200
    static var secondaryShade3: UIColor = Palette.gray300

    static let textPrimaryShade1: UIColor = Palette.gray500
    static let textPrimaryShade2: UIColor = Palette.gray600
    static let textPrimaryShade3: UIColor = Palette.gray800
    static let textPrimaryShade4: UIColor = Palette.gray1000
    static let textPrimaryShade5: UIColor = UIColor(lightHex: "#FFFFFF", darkHex: "#FFFFFF")

    /// gray0 / gray50
    static let backgroundColorPrimary = UIColor(lightHex: "#FFFFFF", darkHex: "#111827")
    /// gray50 / gray0
    static let backgroundColorSecondary = UIColor(lightHex: "#F9FAFB", darkHex: "#0C101B")
    static let backgroundColorTertiary = Palette.gray100

    static var error: UIColor = Palette.error600
    static var success: UIColor = Palette.success600

    static var controlShade1: UIColor = Palette.gray300
    static var controlShade2: UIColor = Palette.gray500
    static var controlAccessoryShade1: UIColor = Palette.gray800
    static var controlAccessoryShade2: UIColor = Palette.gray400
    static var controlBackground: UIColor = Palette.gray100



    static var tintedTitle: UIColor { Palette.white }

    static var tintSecondary: UIColor {
      Palette.clear
    }
  }
}

extension Color {

  struct Fallback {

    static var tintDisabled: UIColor { UIColor.Palette.gray200 }

    static var tintedTitleDisabled: UIColor { UIColor.Palette.gray500 }

    static var tintSecondaryPressed: UIColor { UIColor.Palette.gray100 }
    static var tintSecondaryFocused: UIColor { UIColor.Palette.gray200 }
    static var tintSecondaryDisabled: UIColor { UIColor.Palette.clear }

    static var tintedTitleSecondary: UIColor { UIColor.Palette.gray1000 }
    static var tintedTitleSecondaryDisabled: UIColor { UIColor.Palette.gray400 }
  }
}
