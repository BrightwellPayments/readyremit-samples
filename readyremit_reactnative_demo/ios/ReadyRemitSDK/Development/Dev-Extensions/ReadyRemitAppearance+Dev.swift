//
//  ReadyRemitAppearance+Dev.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import UIKit



#if DEBUG

enum FontName: String {
  case typewriter = "American Typewriter"
  case noteworthy = "Noteworthy"
  case luminari = "Luminari"
  case comic = "Comic Sans MS"
  case roboto = "Roboto"
  case poppins = "Poppins"
  case tenorSans = "Tenor Sans"
}


extension ReadyRemitAppearance {

  public func configureDevelop() {
    let inputStyle = ReadyRemit.InputStyle()
    inputStyle.configureDevelop()
    self.inputStyle = inputStyle

    let dropdown = ReadyRemit.InputSelectionListStyle()
    dropdown.configureDevelop()
    self.dropdownListStyle = dropdown

    let search = ReadyRemit.SearchbarStyle()
    search.configureDevelop()
    self.searchbarStyle = search

    let primary = ReadyRemit.CallForActionButtonStyle()
    primary.configureDevelopPrimary()
    self.primaryButtonStyle = primary

    let secondary = ReadyRemit.CallForActionButtonStyle()
    secondary.configureDevelopSecondary()
    self.secondaryButtonStyle = secondary

    let borderless = ReadyRemit.BorderlessButtonStyle()
    borderless.configureDevelop()
    self.borderlessButtonStyle = borderless
  }

  public func configureOxygen() {
    ReadyRemit.FontSpec.defaultFamily = FontName.poppins.rawValue

    colors.backgroundColorSecondary = UIColor(lightHex: "ffffff", darkHex: "3c2a3c") //322536")

    let inputStyle = ReadyRemit.InputStyle()
    inputStyle.configureOxygen()
    self.inputStyle = inputStyle

//    let dropdown = ReadyRemit.InputSelectionListStyle()
//    dropdown.configureDevelop()
//    self.dropdownListStyle = dropdown
//
//    let search = ReadyRemit.SearchbarStyle()
//    search.configureDevelop()
//    self.searchbarStyle = search

    let primary = ReadyRemit.CallForActionButtonStyle()
    primary.configureOxygenPrimary()
    self.primaryButtonStyle = primary

//    let secondary = ReadyRemit.CallForActionButtonStyle()
//    secondary.configureDevelopSecondary()
//    self.secondaryButtonStyle = secondary
//
//    let borderless = ReadyRemit.BorderlessButtonStyle()
//    borderless.configureDevelop()
//    self.borderlessButtonStyle = borderless
  }
}

extension ReadyRemitColorScheme {

  public func configureCustom(_ type: String = "") {
    primaryShade1 = UIColor(lightHex: type == "" ? "#256EB" : (type == "purple" ? "#6941C6": "#07309D"), darkHex: "#4371D6")
    primaryShade2 = UIColor(lightHex: type == "" ? "#1E4FBC" : (type == "purple" ? "#7F56D9": "#336BFF"), darkHex: "#365AAB")

    secondaryShade1 = UIColor(lightHex: "#F3F4F6", darkHex: "#1F2937")
    secondaryShade2 = UIColor(lightHex: "#E5E7EB", darkHex: "#374151")
    secondaryShade3 = UIColor(lightHex: "#D1D5DB", darkHex: "#4B5563")

    textPrimaryShade1 = UIColor(lightHex: "#6B7280", darkHex: "#9CA3Af")
    textPrimaryShade2 = UIColor(lightHex: type == "" ? "#4B5563" : (type == "purple" ? "#6941C6": "#4575F7"), darkHex: "#D1D5DB")
    textPrimaryShade3 = UIColor(lightHex: type == "" ? "#1F2937" : "#000000", darkHex: "#F3F4F6")
    textPrimaryShade4 = UIColor(lightHex: "#0C101B", darkHex: "#FFFFFF")
    textPrimaryShade5 = UIColor(lightHex: type == "" ? "#FFFFFF" : "#FFFFFF", darkHex: "#FFFFFF")

    backgroundColorPrimary   = UIColor(lightHex: type == "" ? "#F9FAFB" : (type == "purple" ? "#E1BEE7": "#FFCCBC"), darkHex: "#0C101B")
    backgroundColorSecondary = UIColor(lightHex: type == "" ? "#FFFFFF" : (type == "purple" ? "#F9F6FF": "#FF9800"), darkHex: "#111827")
    backgroundColorTertiary  = UIColor(lightHex: "BBAAAA", darkHex: "998888")

    success = UIColor.systemTeal
    error = UIColor.systemOrange

    controlShade1 = UIColor(lightHex: "#D1D5DB", darkHex: "#374151")
    controlShade2 = UIColor(lightHex: type == "" ? "#6B7280" : (type == "purple" ? "#7F56D9": "#2B54C1"), darkHex: "#9CA3AF")
    controlAccessoryShade1 = UIColor(lightHex: type == "" ? "#9CA3AF" : (type == "purple" ? "#7F56D9": "#336BFF"), darkHex: "#6B7280")
    controlAccessoryShade2 = UIColor(lightHex: "#1F2937", darkHex: "#F3F4F6")
  }
}


extension ReadyRemit.InputStyle {

  public func configureDevelop() {
    inputFontSpec = ReadyRemit.FontSpec(family: FontName.luminari.rawValue, size: 14)
    inputFontColor = UIColor(lightHex: "ff9999", darkHex: "ffaaaa")
    // placeholderFontSpec = ReadyRemit.FontSpec(family: FontName.typewriter.rawValue, size: 14)
    placeholderFontColor = UIColor(lightHex: "ff7777", darkHex: "ff5555")
    labelFontSpec = ReadyRemit.FontSpec(family: FontName.luminari.rawValue, size: 12)
    labelFontColor = .blue
    labelFontColorActive = .orange
    labelFontColorDisabled = .red
    infoFontSpec = ReadyRemit.FontSpec(family: FontName.luminari.rawValue, size: 10, italic: true)

    buttonDropdownIcon = UIImage(named: "questionmark")

    borderColorNormal = .systemTeal
    borderColorActive = .systemOrange
    borderColorDisabled = .label
    borderColorSuccess = .systemBlue
    borderColorError = .systemRed

    validationErrorIcon = UIImage(named: "questionmark")
    validationSuccessIcon = UIImage(named: "questionmark")
  }

  public func configureOxygen() {
    inputFontSpec = ReadyRemit.FontSpec(size: 14, weight: .semibold)
    inputFontColor = UIColor(lightHex: "1f1a28", darkHex: "fefefe")
    placeholderFontSpec = ReadyRemit.FontSpec(size: 14, weight: .regular)
    placeholderFontColor = UIColor(lightHex: "6c6677", darkHex: "bdbdc4")
    labelFontSpec = ReadyRemit.FontSpec(size: 13, weight: .none)
    labelFontColor = UIColor(lightHex: "6c6677", darkHex: "bdbdc4")
    labelFontColorActive = UIColor(lightHex: "9769d0", darkHex: "9c7dc5")
    buttonDropdownColor = UIColor(lightHex: "8e58ce", darkHex: "9c7dc5")
    infoFontSpec = ReadyRemit.FontSpec(size: 10)
    borderColorNormal = UIColor(lightHex: "e4e3ec", darkHex: "3e3d4d")
    borderColorActive = UIColor(lightHex: "8e58ce", darkHex: "9c7dc5")
    borderColorSuccess = UIColor(lightHex: "80C080", darkHex: "80C080")
    borderColorError = UIColor(lightHex: "ee7a6c", darkHex: "ee7a6c")
    borderWidth = 1
    borderWidthActivated = 1
    validationErrorIcon = UIImage()
    validationSuccessIcon = UIImage()
  }
}


extension ReadyRemit.InputSelectionListStyle {

  public func configureDevelop() {
    backButtonColor = UIColor(lightHex: "#AFB42B", darkHex: "#CDDC39")
    titleFontSpec = ReadyRemit.FontSpec(family: FontName.luminari.rawValue, size: 10, weight: .semibold, italic: true)
    titleFontColor = UIColor(lightHex: "555555", darkHex: "555555")
    itemFontSpec = ReadyRemit.FontSpec(family: FontName.luminari.rawValue, size: 10, weight: .thin, italic: true)
    itemFontColor = UIColor(lightHex: "888888", darkHex: "888888")
    backgroundColor = UIColor(lightHex: "eeeeee", darkHex: "eeeeee")
  }
}


extension ReadyRemit.SearchbarStyle {

  public func configureDevelop() {
    searchFontSpec = ReadyRemit.FontSpec(family: FontName.luminari.rawValue, size: 13, weight: .bold, italic: false)
    searchFontColor = UIColor(lightHex: "#FFC107", darkHex: "#FFC1FF")
    placeholderFontSpec = ReadyRemit.FontSpec(family: FontName.luminari.rawValue, size: 13, weight: .semibold, italic: true)
    backgroundColor = UIColor(lightHex: "c1c1c1", darkHex: "d2d2d2")
    searchIcon = UIImage(named: "questionmark")
    searchIconColor = UIColor(lightHex: "#CDDC39", darkHex: "#CDDC39")
    clearButtonColor = UIColor(lightHex: "#757575", darkHex: "#757575")
    cancelButtonFontSpec = ReadyRemit.FontSpec(family: FontName.luminari.rawValue, size: 10, weight: .thin, italic: true)
    cancelButtonFontColor = UIColor(lightHex: "#FF5722", darkHex: "#FF5722")
  }
}


extension ReadyRemit.CallForActionButtonStyle {

  public func configureDevelopPrimary() {
    titleFont = ReadyRemit.FontSpec(family: FontName.luminari.rawValue, size: 17, weight: .semibold, italic: true)
    titleFontColor = UIColor(lightHex: "#BDBDBD", darkHex: "#BDBDBD")
    titleFontColorPressed = UIColor(lightHex: "#757575", darkHex: "#757575")
    titleFontColorDisabled = UIColor(lightHex: "#FFFFFF", darkHex: "#FFFFFF")
    backgroundColor = UIColor(lightHex: "#4CAF50", darkHex: "#4CAF50")
    backgroundColorPressed = UIColor(lightHex: "#00BCD4", darkHex: "#00BCD4")
    backgroundColorDisabled = UIColor(lightHex: "", darkHex: "")
    borderColor = UIColor(lightHex: "#00BCD4", darkHex: "#00BCD4")
    borderColorPressed = UIColor(lightHex: "#00BCD4", darkHex: "#00BCD4")
    borderColorDisabled = UIColor(lightHex: "#00BCD4", darkHex: "#00BCD4")
    borderWidth = 3
    borderCornerRadius = 8
  }

  public func configureOxygenPrimary() {
    titleFont = ReadyRemit.FontSpec(family: FontName.poppins.rawValue, size: 17, weight: .semibold)
    titleFontColor = UIColor(lightHex: "ffffff", darkHex: "000000")
    titleFontColorPressed = UIColor(lightHex: "ffffff", darkHex: "000000")
    titleFontColorDisabled = UIColor(lightHex: "d8d2dc", darkHex: "000000")
    backgroundColor = UIColor(lightHex: "000000", darkHex: "987EC1")
    backgroundColorPressed = UIColor(lightHex: "000000", darkHex: "fefefe")
    backgroundColorDisabled = UIColor(lightHex: "e6e4ed", darkHex: "e6e4ed")
    borderWidth = 0
    borderCornerRadius = 0
  }

  public func configureDevelopSecondary() {
    titleFont = ReadyRemit.FontSpec(family: FontName.luminari.rawValue, size: 17, weight: .semibold, italic: true)
    titleFontColor = UIColor(lightHex: "#455A64", darkHex: "#455A64")
    titleFontColorPressed = UIColor(lightHex: "#607D8B", darkHex: "#607D8B")
    titleFontColorDisabled = UIColor(lightHex: "#CFD8DC", darkHex: "#CFD8DC")
    backgroundColor = UIColor(lightHex: "#9E9E9E", darkHex: "#9E9E9E")
    backgroundColorPressed = UIColor(lightHex: "#BDBDBD", darkHex: "#BDBDBD")
    backgroundColorDisabled = UIColor(lightHex: "#9E9E9E", darkHex: "#9E9E9E")
    borderColor = UIColor(lightHex: "#FFC107", darkHex: "#FFC107")
    borderColorPressed = UIColor(lightHex: "#795548", darkHex: "#795548")
    borderColorDisabled = UIColor(lightHex: "#4CAF50", darkHex: "#4CAF50")
    borderWidth = 1
    borderCornerRadius = 4
  }
}


extension ReadyRemit.BorderlessButtonStyle {

  public func configureDevelop() {
    titleFont = ReadyRemit.FontSpec(family: FontName.luminari.rawValue, size: 12, weight: .semibold, italic: true)
    titleFontColor = UIColor(lightHex: "#4CAF50", darkHex: "#4CAF50")
  }
}
#endif
