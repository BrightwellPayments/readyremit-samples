//
//  Height.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 4/12/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI


struct Height : ViewModifier {

  var height: CGFloat?

  func body(content: Content) -> some View {
    if let height = height {
      content.frame(height: height)
    } else {
      content
    }
  }
}
