//
//  ReadyRemitColorConfig.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import UIKit
import SwiftUI


@objc public class ReadyRemitColorScheme : NSObject {

  public var primaryShade1 = UIColor.Fallback.primaryShade1
  public var primaryShade2 = UIColor.Fallback.primaryShade2
  public var secondaryShade1 = UIColor.Fallback.secondaryShade1
  public var secondaryShade2 = UIColor.Fallback.secondaryShade2
  public var secondaryShade3 = UIColor.Fallback.secondaryShade3

  public var textPrimaryShade1 = UIColor.Fallback.textPrimaryShade1
  public var textPrimaryShade2 = UIColor.Fallback.textPrimaryShade2
  public var textPrimaryShade3 = UIColor.Fallback.textPrimaryShade3
  public var textPrimaryShade4 = UIColor.Fallback.textPrimaryShade4
  public var textPrimaryShade5 = UIColor.Fallback.textPrimaryShade5

  public var backgroundColorPrimary = UIColor.Fallback.backgroundColorPrimary
  public var backgroundColorSecondary = UIColor.Fallback.backgroundColorSecondary
  public var backgroundColorTertiary = UIColor.Fallback.backgroundColorTertiary

  public var error = UIColor.Fallback.error
  public var success = UIColor.Fallback.success
  
  public var errorBackground = (light: UIColor.Palette.error50, dark: UIColor.Palette.error1000)

  public var controlShade1 = UIColor.Fallback.controlShade1
  public var controlShade2 = UIColor.Fallback.controlShade2
  public var controlAccessoryShade1 = UIColor.Fallback.controlAccessoryShade1
  public var controlAccessoryShade2 = UIColor.Fallback.controlAccessoryShade2


  public var textPrimaryDisabled = UIColor.Palette.gray500
  public var textTertiaryDisabled = UIColor.Palette.gray500
  public var textQuaternaryDisabled = UIColor.clear
  
  public var inputUnderLineActive = (light: UIColor.Palette.primary600, dark: UIColor.Palette.primary500)
}
