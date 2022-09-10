//
//  HeightPreferenceKey.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct HeightPreferenceKey: PreferenceKey {

  static var defaultValue: CGFloat = 100

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = min(value, nextValue())
  }
}
