//
//  ValidationErrorCardView.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 4/5/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI


struct ValidationErrorCardView: View, AppearanceConsumer {
  var fieldLabelActions: [String]
  
  var body: some View {
    HStack(alignment: .top){
      createErrorImage()
        .foregroundColor(iconColor)
      VStack(alignment: .leading, spacing: 4) {
        Text(L10n.rrmValidationTitle)
          .padding(.bottom, 4)
          .foregroundColor(titleColor)
          .font(titleFont)
        Text(L10n.rrmValidationReviewInstruction)
          .foregroundColor(messageColor)
          .font(messageFont)
        ForEach(fieldLabelActions, id: \.self) { fieldLabelAction in
          HStack {
            Text("•")
            Text(fieldLabelAction)
              .bold()
          }
          .font(messageFont)
          .foregroundColor(messageColor)
          .padding(.leading, 8)
        }
      }
      Spacer()
    }
    .padding(EdgeInsets(top: 10, leading: 13, bottom: 10, trailing: 13))
    .modifier(CardView())
  }
  
  func createErrorImage() -> Image {
    if let uiImage = Self.appearance.inputStyle.validationErrorIcon {
      return Image(uiImage: uiImage)
    }
    return Image(systemName: "exclamationmark.circle.fill")
  }
  
  var iconColor: Color {
    Self.appearance.inputStyle.borderColorError?.color ?? Self.appearance.colors.error.color
  }
  var titleColor: Color { Self.appearance.dropdownListStyle.titleFontColor?.color ?? Self.appearance.colors.textPrimaryShade4.color }
  var titleFont: Font {
    let spec = Self.appearance.dropdownListStyle.titleFontSpec ?? Self.appearance.fonts.headline
    return .font(spec: spec, style: .headline)
  }
  var messageColor: Color { Self.appearance.inputStyle.inputFontColor?.color ?? Self.appearance.colors.textPrimaryShade4.color }
  var messageFont: Font {
    let spec = Self.appearance.inputStyle.infoFontSpec ?? Self.appearance.fonts.subheadline
    return .font(spec: spec, style: .subheadline)
  }
}


#if DEBUG

struct ValidationErrorCardView_Previews: PreviewProvider {
  static let fieldTitles: [String] = ["DOB", "Send Amount", "They Receive"]
  
  static var previews: some View {
    ValidationErrorCardView(fieldLabelActions: fieldTitles)
  }
}

#endif
