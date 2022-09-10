//
//  UIFont.Weight+Font.Weight.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI
import UIKit


extension UIFont.Weight {

  var fontWeight: Font.Weight {
    switch self {
    case .ultraLight: return .ultraLight
    case .thin: return .thin
    case .light: return .light
    case .regular: return .regular
    case .medium: return .medium
    case .semibold: return .semibold
    case .bold: return .bold
    case .heavy: return .heavy
    case .black: return .black
    default: return .regular
    }
  }
}
