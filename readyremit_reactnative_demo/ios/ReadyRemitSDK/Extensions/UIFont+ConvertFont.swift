//
//  UIFont+convertFont.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/17/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI


extension UIFont {
  class func convertFont(from font: Font) -> UIFont {
    let style: UIFont.TextStyle
    if #available(iOS 14.0, *) {
      switch font {
      case .title2:      style = .title2
      case .title3:      style = .title3
      case .caption2:    style = .caption2
      case .largeTitle:  style = .largeTitle
      case .title:       style = .title1
      case .headline:    style = .headline
      case .subheadline: style = .subheadline
      case .callout:     style = .callout
      case .caption:     style = .caption1
      case .footnote:    style = .footnote
      case .body: fallthrough
      default:           style = .body
      }
    } else {
      switch font {
      case .largeTitle:  style = .largeTitle
      case .title:       style = .title1
      case .headline:    style = .headline
      case .subheadline: style = .subheadline
      case .callout:     style = .callout
      case .caption:     style = .caption1
      case .footnote:    style = .footnote
      case .body: fallthrough
      default:           style = .body
      }
    }
    return  UIFont.preferredFont(forTextStyle: style)
  }
}
