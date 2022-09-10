//
//  Color+Hex.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI
import UIKit


extension Color {

  init(hex: String) {
    self.init(UIColor(hex: hex))
  }
}
