//
//  ExpandedInfoSheet.swift
//  ReadyRemitSDK
//
//  Copyright © 2022 Brightwell. All rights reserved.
//

import Combine
import SwiftUI


struct ExpandedInfoSheet : View, AppearanceConsumer {
  
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.presentationMode) var presentation
  let info: String
  
  var body: some View {
    VStack {
      Spacer()
      VStack(spacing: 20) {
        ScrollView {
          HStack(alignment: .top, spacing: 12) {
            createInfoIcon()
              .foregroundColor(infoIconColor)
            Text(info)
              .font(infoFont)
              .foregroundColor(infoForegroundColor)
          }
        }
        Spacer()
      }
      .padding()
      .background(backgroundColor)
      .cornerRadius(8)
      .frame(height: listHeight)
      .onTapGesture { hideKeyboard() }
    }
    .background(DynamicSizeSheetBackgroundView().onTapGesture(perform: dismiss))
    .edgesIgnoringSafeArea(.all)
  }

  func dismiss() {
    presentation.wrappedValue.dismiss()
  }

  var listHeight: CGFloat? {
    UIScreen.main.bounds.height / 3
  }

  var backgroundColor: Color {
    Self.appearance.dropdownListStyle.backgroundColor?.color
    ?? Self.appearance.colors.backgroundColorPrimary.color
  }
  
  var infoFont: Font {
    let spec = Self.appearance.inputStyle.infoFontSpec ?? Self.appearance.fonts.footnote
    return .font(spec: spec, style: .footnote)
  }
  
  var infoForegroundColor: Color {
    Self.appearance.inputStyle.infoFontColor?.color ??
    ((colorScheme == .light) ?
     Self.appearance.colors.textPrimaryShade3.color : Self.appearance.colors.textPrimaryShade4.color)
  }
  
  var infoIconColor: Color {
    (colorScheme == .light) ?
    Self.appearance.colors.inputUnderLineActive.light.color : Self.appearance.colors.inputUnderLineActive.dark.color
  }
  
  func createInfoIcon() -> Image {
    if let uiImage = Self.appearance.inputStyle.infoIcon {
      return Image(uiImage: uiImage)
    }
    return Image(systemName: "info.circle")
  }
}
