//
//  Placeholder.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct PlaceHolder<T: View>: ViewModifier {

  var show: Bool
  var placeHolder: T

  func body(content: Content) -> some View {
    ZStack(alignment: .leading) {
      if show { placeHolder }
      content
    }
  }
}


extension View {

  func placeHolder<T: View>(_ holder: T, show: Bool) -> some View {
    modifier(PlaceHolder(show: show, placeHolder: holder))
  }
}
