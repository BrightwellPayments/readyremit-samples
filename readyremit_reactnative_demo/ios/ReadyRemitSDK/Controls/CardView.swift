//
//  CardView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct CardView: ViewModifier, AppearanceConsumer {

  var backgroundColor: Color = Self.appearance.colors.backgroundColorPrimary.color
  
  func body(content: Content) -> some View {
    VStack() {
      Divider()
      content
      Divider()
    }.background(backgroundColor)
  }
}


#if DEBUG

struct CardView_Previews: PreviewProvider, AppearanceConsumer {
  static var previews: some View {
    Group {
      Text("Hello I am a Card")
        .modifier(CardView())
        .previewLayout(.fixed(width: 400, height: 180))
    }
  }
}

#endif
