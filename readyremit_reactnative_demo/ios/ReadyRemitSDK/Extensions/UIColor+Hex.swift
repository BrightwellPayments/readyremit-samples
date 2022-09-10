//
//  Color+Hex.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import UIKit


extension UIColor {

  public convenience init(hex: String) {
    var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if cString.hasPrefix("#") {
      cString.remove(at: cString.startIndex)
    }
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 1.0
    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    if cString.count == 6 {
      red   = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
      green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
      blue  = CGFloat( rgbValue & 0x0000FF) / 255.0
    }
    if cString.count == 8 {
      red   = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
      green = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
      blue  = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255
      alpha = CGFloat( rgbValue & 0x000000FF) / 255.0
    }
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  public convenience init(lightHex: String, darkHex: String) {
    self.init {
      UIColor(hex: $0.userInterfaceStyle == .light ? lightHex : darkHex)
    }
  }
}


#if DEBUG

extension UIColor {
  var hex: String { cgColor.hex }
}


extension CGColor {
  var hex: String {
    let r: CGFloat = components?[0] ?? 0.0
    let g: CGFloat = components?[1] ?? 0.0
    let b: CGFloat = components?[2] ?? 0.0
    return String(format: "#%02lX%02lX%02lX",
                  lroundf(Float(r * 255)),
                  lroundf(Float(g * 255)),
                  lroundf(Float(b * 255)))
  }
}

#endif
