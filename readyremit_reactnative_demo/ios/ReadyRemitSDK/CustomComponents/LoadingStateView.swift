//
//  LoadingStateView.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 1/27/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI

  
struct LoadingStateView: View {
 
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    ActivityIndicator(animated: true,
                      foregroundColor: spinnerColor,
                      style: .large)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
      .background(backgroundColor)
      .opacity(0.4)
      .edgesIgnoringSafeArea(.all)
      .allowsHitTesting(true)
  }
  
  var backgroundColor: Color {
    (colorScheme == .light) ? UIColor.Palette.gray1000.color : UIColor.Palette.gray0.color
  }
  
  var spinnerColor: UIColor {
    (colorScheme == .light) ? .black : .white
  }
}

struct LoadingStateView_Previews: PreviewProvider {
  static var previews: some View {
    LoadingStateView()
  }
}
