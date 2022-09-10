//
//  ColorsDemo.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
#if DEBUG

import SwiftUI


struct ColorsDemoView : View {
  static var colors: ReadyRemitColorScheme {
    ReadyRemit.shared.appearance.colors
  }
  let textColors = [
    (UIColor.Fallback.primaryShade1, "Primary Shade 1", Self.colors.primaryShade1),
    (UIColor.Fallback.primaryShade2, "Primary Shade 2", Self.colors.primaryShade2),

    (UIColor.Fallback.secondaryShade1, "Secondary Shade 1", Self.colors.secondaryShade1),
    (UIColor.Fallback.secondaryShade2, "Secondary Shade 2", Self.colors.secondaryShade2),
    (UIColor.Fallback.secondaryShade3, "Secondary Shade 3", Self.colors.secondaryShade3),

    (UIColor.Fallback.textPrimaryShade1, "Text Primary Shade 1", Self.colors.textPrimaryShade1),
    (UIColor.Fallback.textPrimaryShade2, "Text Primary Shade 2", Self.colors.textPrimaryShade2),
    (UIColor.Fallback.textPrimaryShade3, "Text Primary Shade 3", Self.colors.textPrimaryShade3),
    (UIColor.Fallback.textPrimaryShade4, "Text Primary Shade 4", Self.colors.textPrimaryShade4),
    (UIColor.Fallback.textPrimaryShade5, "Text Primary Shade 5", Self.colors.textPrimaryShade5),

    (UIColor.Fallback.backgroundColorPrimary, "Background primary", Self.colors.backgroundColorPrimary),
    (UIColor.Fallback.backgroundColorSecondary, "Background secondary", Self.colors.backgroundColorSecondary),
    (UIColor.Fallback.backgroundColorTertiary, "Background tertiary", Self.colors.backgroundColorTertiary),

    (UIColor.Fallback.error, "Error", Self.colors.error),
    (UIColor.Fallback.success, "Success", Self.colors.success),

    (UIColor.Fallback.controlShade1, "Control Shade 1", Self.colors.controlShade1),
    (UIColor.Fallback.controlShade2, "Control Shade 2", Self.colors.controlShade2),
    (UIColor.Fallback.controlAccessoryShade1, "Control Accessory Shade 1", Self.colors.controlAccessoryShade1),
    (UIColor.Fallback.controlAccessoryShade2, "Control Accessory Shade 2", Self.colors.controlAccessoryShade2),
  ]
  func coerceColor(_ uicolor: UIColor?) -> UIColor {
    uicolor ?? .white
  }
  func cornersForItem(_ item: (UIColor, String, UIColor?)) -> UIRectCorner {
    if item == textColors.first! {
      return [.topLeft, .topRight]
    }
    if item == textColors.last! {
      return [.bottomLeft, .bottomRight]
    }
    return []
  }
  var body: some View {
    ScrollView {
      VStack(spacing: 8) {
        HStack {
          Text("Fallback / Base Colors").modifier(Title3Text())
          Spacer()
        }.padding()
        VStack(spacing: 0) {
          ForEach(textColors, id: \.self.1) { item in
            HStack {
              Color(item.0)
                .frame(width: 40, height: 32)
                .cornerRadius(10, corners: cornersForItem(item))
              Text("\(item.0.hex)")
                .frame(width: 80)
              Text("\(item.1)")
              Spacer()
              Color(coerceColor(item.2))
                .frame(width: 40, height: 32)
                .cornerRadius(10, corners: cornersForItem(item))
            }
          }
        }
        .font(.system(size: 12)).fixedSize()
        .padding()

        VStack {
          HStack() {
            Text("Background Demo")
            Spacer()
          }
          .padding([.leading, .trailing], 8)
          .modifier(CardView())
          Spacer(minLength: 40)
        }
        Spacer()
      }
      .navigationBarTitle("Colors")
      .background(Color(UIColor.Fallback.backgroundColorSecondary))
    }
  }
}

struct ColorsDemoView_Previews: PreviewProvider {
  static var previews: some View {
    ColorsDemoView().previewLayout(.fixed(width: 400, height: 600))
  }
}

#endif
