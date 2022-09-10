//
//  ActivityIndicator.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 1/27/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI


struct ActivityIndicator: UIViewRepresentable {
  
  @Environment(\.colorScheme) var colorScheme
  var animated: Bool
  var foregroundColor = UIColor.white
  var style: UIActivityIndicatorView.Style = .medium
  
  func makeUIView(context: Context) -> UIActivityIndicatorView {
    let indicator = UIActivityIndicatorView(style: style)
    indicator.color = foregroundColor
    return indicator
  }
  
  func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    if self.animated {
      uiView.startAnimating()
    } else {
      uiView.stopAnimating()
    }
  }
}


#if DEBUG

struct ActivityIndicator_Previews: PreviewProvider {
  
  static var previews: some View {
    ActivityIndicator(animated: true)
  }
}
#endif
