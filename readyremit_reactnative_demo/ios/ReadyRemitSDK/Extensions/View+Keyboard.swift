//
//  View+Keyboard.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


#if canImport(UIKit)

extension View {
  
  func readTextSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: TextHeightPreferenceKey.self, value: geometryProxy.size)
      }
    )
      .onPreferenceChange(TextHeightPreferenceKey.self, perform: onChange)
  }
      
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil,
                                    from: nil,
                                    for: nil)
  }
}
#endif
