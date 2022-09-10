//
//  FontSpec.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import UIKit
import SwiftUI


public extension ReadyRemit {

  struct FontSpec {

    public static var defaultFamily: String?
    public static var dynamicFontsize: Bool = true

    private let _family: String?
    let size: CGFloat?
    let weight: UIFont.Weight?
    let italic: Bool

    public init(family: String? = nil,
                size: CGFloat? = nil,
                weight: UIFont.Weight? = nil,
                italic: Bool = false) {
      self._family = family
      self.size = size
      self.weight = weight
      self.italic = italic
    }

    var family: String? {
      _family ?? Self.defaultFamily
    }
  }


  class CallForActionButtonStyle {
    public var titleFont: ReadyRemit.FontSpec?
    public var titleFontColor: UIColor?
    public var titleFontColorPressed: UIColor?
    public var titleFontColorDisabled: UIColor?
    public var backgroundColor: UIColor?
    public var backgroundColorPressed: UIColor?
    public var backgroundColorDisabled: UIColor?
    public var borderColor: UIColor?
    public var borderColorPressed: UIColor?
    public var borderColorDisabled: UIColor?
    public var borderWidth: CGFloat?
    public var borderCornerRadius: CGFloat?

    public init(titleFont: ReadyRemit.FontSpec? = nil,
                titleFontColor: UIColor? = nil,
                titleFontColorPressed: UIColor? = nil,
                titleFontColorDisabled: UIColor? = nil,
                backgroundColor: UIColor? = nil,
                backgroundColorPressed: UIColor? = nil,
                backgroundColorDisabled: UIColor? = nil,
                borderColor: UIColor? = nil,
                borderColorPressed: UIColor? = nil,
                borderColorDisabled: UIColor? = nil,
                borderWidth: CGFloat? = nil,
                borderCornerRadius: CGFloat? = nil) {
      self.titleFont = titleFont
      self.titleFontColor = titleFontColor
      self.titleFontColorPressed = titleFontColorPressed
      self.titleFontColorDisabled = titleFontColorDisabled
      self.backgroundColor = backgroundColor
      self.backgroundColorPressed = backgroundColorPressed
      self.backgroundColorDisabled = backgroundColorDisabled
      self.borderColor = borderColor
      self.borderColorPressed = borderColorPressed
      self.borderColorDisabled = borderColorDisabled
      self.borderWidth = borderWidth
      self.borderCornerRadius = borderCornerRadius
    }
  }


  class BorderlessButtonStyle {
    var titleFont: FontSpec?
    var titleFontColor: UIColor?
    var titleFontColorPressed: UIColor?
    var titleFontColorDisabled: UIColor?

    public init(titleFont: ReadyRemit.FontSpec? = nil,
                titleFontColor: UIColor? = nil,
                titleFontColorPressed: UIColor? = nil,
                titleFontColorDisabled: UIColor? = nil) {
      self.titleFont = titleFont
      self.titleFontColor = titleFontColor
      self.titleFontColorPressed = titleFontColorPressed
      self.titleFontColorDisabled = titleFontColorDisabled
    }
  }


  class InputStyle {

    public init(inputFontSpec: ReadyRemit.FontSpec? = nil,
                inputFontColor: UIColor? = nil,
                inputFontColorDisabled: UIColor? = nil,
                dateLabelFontSpec: FontSpec? = nil,
                dateLabelColor: UIColor? = nil,
                placeholderFontSpec: ReadyRemit.FontSpec? = nil,
                placeholderFontColor: UIColor? = nil,
                placeholderFontColorDisabled: UIColor? = nil,
                requiredIndicatorColor: UIColor? = nil,
                labelFontSpec: ReadyRemit.FontSpec? = nil,
                labelFontColor: UIColor? = nil,
                labelFontColorActive: UIColor? = nil,
                labelFontColorDisabled: UIColor? = nil,
                infoFontSpec: ReadyRemit.FontSpec? = nil,
                infoFontColor: UIColor? = nil,
                infoFontColorActive: UIColor? = nil,
                infoFontColorDisabled: UIColor? = nil,
                infoIcon: UIImage? = nil,
                buttonDeleteColor: UIColor? = nil,
                buttonDropdownIcon: UIImage? = nil,
                buttonDropdownColor: UIColor? = nil,
                buttonDropdownColorDisabled: UIColor? = nil,
                borderColorNormal: UIColor? = nil,
                borderColorActive: UIColor? = nil,
                borderColorDisabled: UIColor? = nil,
                borderColorSuccess: UIColor? = nil,
                borderColorError: UIColor? = nil,
                borderWidth: CGFloat? = nil,
                borderWidthActivated: CGFloat? = nil,
                validationFontSpec: ReadyRemit.FontSpec? = nil,
                validationErrorIcon: UIImage? = nil,
                validationSuccessIcon: UIImage? = nil,
                hyperlinkColor: UIColor? = nil) {
      self.inputFontSpec = inputFontSpec
      self.inputFontColor = inputFontColor
      self.inputFontColorDisabled = inputFontColorDisabled
      self.dateLabelFontSpec = dateLabelFontSpec
      self.dateLabelColor = dateLabelColor
      self.placeholderFontSpec = placeholderFontSpec
      self.placeholderFontColor = placeholderFontColor
      self.placeholderFontColorDisabled = placeholderFontColorDisabled
      self.requiredIndicatorColor = requiredIndicatorColor
      self.labelFontSpec = labelFontSpec
      self.labelFontColor = labelFontColor
      self.labelFontColorActive = labelFontColorActive
      self.labelFontColorDisabled = labelFontColorDisabled
      self.infoFontSpec = infoFontSpec
      self.infoFontColor = infoFontColor
      self.infoFontColorActive = infoFontColorActive
      self.infoFontColorDisabled = infoFontColorDisabled
      self.infoIcon = infoIcon
      self.buttonDeleteColor = buttonDeleteColor
      self.buttonDropdownIcon = buttonDropdownIcon
      self.buttonDropdownColor = buttonDropdownColor
      self.buttonDropdownColorDisabled = buttonDropdownColorDisabled
      self.borderColorNormal = borderColorNormal
      self.borderColorActive = borderColorActive
      self.borderColorDisabled = borderColorDisabled
      self.borderColorSuccess = borderColorSuccess
      self.borderColorError = borderColorError
      self.borderWidth = borderWidth
      self.borderWidthActivated = borderWidthActivated
      self.validationFontSpec = validationFontSpec
      self.validationErrorIcon = validationErrorIcon
      self.validationSuccessIcon = validationSuccessIcon
      self.hyperlinkColor = hyperlinkColor
    }

    var inputFontSpec: FontSpec?
    var inputFontColor: UIColor?
    var inputFontColorDisabled: UIColor?
    var dateLabelFontSpec: FontSpec?
    var dateLabelColor: UIColor?
    var placeholderFontSpec: FontSpec?
    var placeholderFontColor: UIColor?
    var placeholderFontColorDisabled: UIColor?
    var requiredIndicatorColor: UIColor?
    var labelFontSpec: FontSpec?
    var labelFontColor: UIColor?
    var labelFontColorActive: UIColor?
    var labelFontColorDisabled: UIColor?
    var infoFontSpec: FontSpec?
    var infoFontColor: UIColor?
    var infoFontColorActive: UIColor?
    var infoFontColorDisabled: UIColor?
    var infoIcon: UIImage?
    var buttonDeleteColor: UIColor?
    var buttonDropdownIcon: UIImage?
    var buttonDropdownColor: UIColor?
    var buttonDropdownColorDisabled: UIColor?
    var borderColorNormal: UIColor?
    var borderColorActive: UIColor?
    var borderColorDisabled: UIColor?
    var borderColorSuccess: UIColor?
    var borderColorError: UIColor?
    var borderWidth: CGFloat?
    var borderWidthActivated: CGFloat?
    var validationFontSpec: FontSpec?
    var validationErrorIcon: UIImage?
    var validationSuccessIcon: UIImage?
    var hyperlinkColor: UIColor?

    @ViewBuilder internal func createDropdownIcon(withHeight height: CGFloat)
    -> some View {
      if let image = buttonDropdownIcon {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(width: height, height: height)
      } else {
        Image(systemName: "chevron.down")
      }
    }
  }


  class InputSelectionListStyle {

    public init(backButtonColor: UIColor? = nil,
                titleFontSpec: ReadyRemit.FontSpec? = nil,
                titleFontColor: UIColor? = nil,
                itemFontSpec: ReadyRemit.FontSpec? = nil,
                itemFontColor: UIColor? = nil,
                backgroundColor: UIColor? = nil) {
      self.backButtonColor = backButtonColor
      self.titleFontSpec = titleFontSpec
      self.titleFontColor = titleFontColor
      self.itemFontSpec = itemFontSpec
      self.itemFontColor = itemFontColor
      self.backgroundColor = backgroundColor
    }

    var backButtonColor: UIColor?
    var titleFontSpec: FontSpec?
    var titleFontColor: UIColor?
    var itemFontSpec: FontSpec?
    var itemFontColor: UIColor?
    var backgroundColor: UIColor?
  }


  class SearchbarStyle {

    public init(searchFontSpec: ReadyRemit.FontSpec? = nil,
                searchFontColor: UIColor? = nil,
                placeholderFontSpec: ReadyRemit.FontSpec? = nil,
                backgroundColor: UIColor? = nil,
                searchIcon: UIImage? = nil,
                searchIconColor: UIColor? = nil,
                clearButtonColor: UIColor? = nil,
                cancelButtonFontSpec: ReadyRemit.FontSpec? = nil,
                cancelButtonFontColor: UIColor? = nil) {
      self.searchFontSpec = searchFontSpec
      self.searchFontColor = searchFontColor
      self.placeholderFontSpec = placeholderFontSpec
      self.backgroundColor = backgroundColor
      self.searchIcon = searchIcon
      self.searchIconColor = searchIconColor
      self.clearButtonColor = clearButtonColor
      self.cancelButtonFontSpec = cancelButtonFontSpec
      self.cancelButtonFontColor = cancelButtonFontColor
    }

    var searchFontSpec: FontSpec?
    var searchFontColor: UIColor?
    var placeholderFontSpec: FontSpec?
    var backgroundColor: UIColor?
    var searchIcon: UIImage?
    var searchIconColor: UIColor?
    var clearButtonColor: UIColor?
    var cancelButtonFontSpec: FontSpec?
    var cancelButtonFontColor: UIColor?
  }
}
