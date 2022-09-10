//
//  Font.TextStyle+Convenience.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


extension Font.TextStyle {

  var font: Font {
    switch self {
    case .largeTitle, .title, .title2, .title3:
      if #available(iOS 14.0, *) {
        return .title3
      } else {
        return .title
      }
    case .body: return .body
    case .headline: return .headline
    case .callout: return .callout
    case .subheadline: return .subheadline
    case .footnote: return .footnote
    case .caption, .caption2: return .caption
    @unknown default:
      return Self.body.font
    }
  }

  var uifontStyle: UIFont.TextStyle {
    switch self {
    case .largeTitle, .title, .title2, .title3:
      return .title1
    case .body: return .body
    case .headline: return .headline
    case .callout: return .callout
    case .subheadline: return .subheadline
    case .footnote: return .footnote
    case .caption, .caption2: return .caption1
    @unknown default:
      return Self.body.uifontStyle
    }
  }

  var baseFontSize: CGFloat {
    switch self {
    case .largeTitle: return 34
    case .title: return 28
    case .title2: return 22
    case .title3: return 20
    case .headline: return 17
    case .body: return 17
    case .callout: return 16
    case .subheadline: return 15
    case .footnote: return 13
    case .caption: return 12
    case .caption2: return 11
    @unknown default:
      return Self.body.baseFontSize
    }
  }
}
