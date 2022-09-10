//
//  HorizontalButtonView.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 18/07/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//

import SwiftUI

struct HorizontalButtonView: View, AppearanceConsumer {
  var title: String = ""
  var buttonText: String = ""
  var function: () -> Void
  
    var body: some View {
      HStack {
        Text(title)
        .padding(.horizontal, 16)
        .padding(.top, 2)
        .foregroundColor(titleTextColor)
        .font(labelsFont)
        Spacer()
        Button(action: {
          self.function()
          }, label: {
            Text(buttonText)
              .font(buttonFont)
              .foregroundColor(buttonTextColor)
          })
        .frame(width: 50, height: 20, alignment: .trailing)
        .padding(.trailing, 16)
        .hidden()
      }.frame(
        minWidth: 0,
        maxWidth: .infinity,
        minHeight: 0,
        maxHeight: .infinity,
        alignment: .topLeading
      )
      .padding(.top, 12)
  }
  var buttonTextColor: Color {
    Self.appearance.colors.textPrimaryShade4.color
  }
  var titleTextColor: Color {
    Self.appearance.colors.textPrimaryShade3.color
  }
  var labelsFont: Font {
    let spec = Self.appearance.textfieldSubtitleFont
    return .font(spec: spec, style: .headline)
  }
  var buttonFont: Font {
    let spec = Self.appearance.textfieldSubtitleFont
    return .font(spec: spec, style: .callout)
  }
}

struct HorizontalButtonView_Previews: PreviewProvider {
  static func printValue() { print("value") }
    static var previews: some View {
      HorizontalButtonView(title: "title", buttonText: "button", function: { self.printValue() })
    }
}
