//
//  SelectiveRoundedCorners.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
#if DEBUG

import SwiftUI


struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    Path(UIBezierPath(roundedRect: rect,
                      byRoundingCorners: corners,
                      cornerRadii: CGSize(width: radius,
                                          height: radius))
          .cgPath
    )
  }
}


extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

#endif
