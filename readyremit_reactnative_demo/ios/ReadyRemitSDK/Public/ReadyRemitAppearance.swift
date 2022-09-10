//
//  ReadyRemitAppearance.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import UIKit
import SwiftUI


@objc public class ReadyRemitAppearance : NSObject {

  @objc public static let shared = ReadyRemitAppearance()

  @objc public var colors: ReadyRemitColorScheme
  @objc public var fonts: ReadyRemitFonts

  public init(fonts: ReadyRemitFonts,
              colors: ReadyRemitColorScheme) {
    self.fonts = fonts
    self.colors = colors
  }

  public init(fonts: ReadyRemitFonts) {
    self.fonts = fonts
    self.colors = ReadyRemitColorScheme()
  }

  public init(colors: ReadyRemitColorScheme) {
    self.fonts = ReadyRemitFonts()
    self.colors = colors
  }

  public override init() {
    fonts = ReadyRemitFonts()
    colors = ReadyRemitColorScheme()
  }


  public var primaryButtonStyle = ReadyRemit.CallForActionButtonStyle()
  public var secondaryButtonStyle = ReadyRemit.CallForActionButtonStyle()
  public var borderlessButtonStyle = ReadyRemit.BorderlessButtonStyle()
  public var inputStyle = ReadyRemit.InputStyle()
  public var dropdownListStyle = ReadyRemit.InputSelectionListStyle()
  public var searchbarStyle = ReadyRemit.SearchbarStyle()

  typealias FontSpec = ReadyRemit.FontSpec

  // vvv These colors need to be refactored/removed vvv //

  public lazy var inputLabelFont: ReadyRemit.FontSpec? = fonts.callout
  public lazy var textfieldSubtitleFont: ReadyRemit.FontSpec? = fonts.caption
  public lazy var textfieldSubheadlineFont: ReadyRemit.FontSpec? = fonts.subheadline
  public var textfieldInfoIcon: UIImage? = nil
  public lazy var textfieldInfoIconColor: UIColor = colors.controlShade2
  public lazy var textfieldErrorColor: UIColor = colors.error
  
  @objc public var primaryButtonColor: UIColor = UIColor(hex: "007AFF")
  
  // Card
  @objc public var titleColor: UIColor = UIColor.black
  @objc public var titleFont: UIFont = UIFont.systemFont(ofSize: 16)
  
  @objc public var pageTitleFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
  
  @objc public var fieldTitleFont: UIFont = UIFont.systemFont(ofSize: 15)
  @objc public var fieldValueFont: UIFont = UIFont.systemFont(ofSize: 16)
  @objc public var fieldBorderColor: UIColor = UIColor(hex: "3C3C43").withAlphaComponent(0.3)
  @objc public var dividerColor: UIColor = UIColor(hex: "E5E7EB")
  @objc public var removeColor: UIColor = UIColor(hex: "979797")
  
  @objc public var buttonColor: UIColor = UIColor(hex: "F3F3F9")
  
  @objc public var disabledColor: UIColor = UIColor(hex: "3C3C43").withAlphaComponent(0.6)
  @objc public var disabledFont: UIFont = UIFont.systemFont(ofSize: 16)
  
  @objc public var highlightedBackgroundColor: UIColor = UIColor(hex: "EBEBF5").withAlphaComponent(0.6)
  @objc public var highlightedCapsuleFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
  @objc public var disabledCapsuleFont: UIFont = UIFont.systemFont(ofSize: 13)
  
  @objc public var currencyDisableColor: UIColor = UIColor(hex: "6B7280")
  @objc public var currencyDisableFont: UIFont = UIFont.systemFont(ofSize: 13)
  
  @objc public var transferMoneyColor: UIColor = UIColor(hex: "111827")
  @objc public var transferMoneyFont: UIFont = UIFont.systemFont(ofSize: 22, weight: .bold)
  
  // Navigation Appearance
  @objc public var navigationFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
  @objc public var navigationCancelFont: UIFont = UIFont.systemFont(ofSize: 17)
  @objc public var navigationColor: UIColor = UIColor(hex: "007AFF")
  @objc public var navigationCancelColor: UIColor = UIColor(hex: "848488")
  
  @objc public var backgroundColor: UIColor = UIColor(hex: "FAFAFA")
  
  @objc public var modalTitleFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
  @objc public var modalTransparentColor: UIColor = UIColor(hex: "000000").withAlphaComponent(0.4)
  
  @objc public var noteFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .medium)
}
