//
//  FieldLabel.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct FieldLabel: View {
  
  @Environment(\.colorScheme) var colorScheme
  let title: String
  var required: Bool = true
  var infoAction: (() -> Void)? = nil
  @State var height: CGFloat = 100
  let appearance = ReadyRemit.shared.appearance

  var body: some View {
    HStack(spacing: 4) {
      if required {
        Text("*")
          .foregroundColor(Color(appearance.textfieldErrorColor))
      }
      Text(title)
        .foregroundColor(labelColor)
        .background(GeometryReader { reader in
          Color.clear.preference(key: HeightPreferenceKey.self, value: reader.size.height)
        })
      if infoAction != nil {
        HStack {
          if let image = appearance.textfieldInfoIcon {
            Image(uiImage: image)
            .resizable()
            .frame(width: height, height: height)
            .scaledToFit()
          } else {
            Image(systemName: "questionmark.circle")
              .foregroundColor(Color(appearance.textfieldInfoIconColor))
              .scaleEffect(0.88)
          }
        }
        .onTapGesture { infoAction?() }
      }
      Spacer()
    }
    .font(labelFont)
    .onPreferenceChange(HeightPreferenceKey.self, perform: { height = $0 })
  }
  
  var labelFont: Font {
    let spec = appearance.inputStyle.labelFontSpec ?? appearance.inputLabelFont
    return .font(spec: spec, style: .callout)
  }
  var labelColor: Color {
    appearance.inputStyle.labelFontColor?.color
    ?? ((colorScheme == .light) ? appearance.colors.textPrimaryShade3.color : appearance.colors.textPrimaryShade4.color)
  }
}


struct FieldTitleView_Previews: PreviewProvider {

  static var previews: some View {
    VStack() {
      FieldLabel(title: "Required field", required: true, infoAction: {})
      FieldLabel(title: "Required field (no info)", required: true)
      FieldLabel(title: "Optional field", required: false, infoAction: {})
      FieldLabel(title: "Optional field (no info)", required: false)
    }
    .padding()
    .previewLayout(.fixed(width: 300, height: 200))
  }
}
