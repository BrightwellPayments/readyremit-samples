//
//  ExchangeRateLabelView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct ExchangeRateLabelView: View, AppearanceConsumer {
  
  var srcCurrencyIsoCode: String
  var dstCurrencyIsoCode: String
  var disabledRightLabel: Bool = true
  @Binding var transferRate: String
  
  var body: some View {
    HStack {
      Text(L10n.rrmExchangeRate)
        .foregroundColor(Color(Self.appearance.currencyDisableColor))
        .font(labelFont)
      Spacer()
      
      Text("1 \(srcCurrencyIsoCode) = \(transferRate) \(dstCurrencyIsoCode)")
        .foregroundColor(rightLabelColor)
        .font(labelFont)
    }.padding(.horizontal, 16)
  }
  
  var labelFont: Font {
    let spec = Self.appearance.inputStyle.labelFontSpec ?? Self.appearance.fonts.subheadline
    return .font(spec: spec, style: .subheadline)
  }
  var rightLabelColor: Color {
    return disabledRightLabel ? ReadyRemitAppearance.shared.currencyDisableColor.color : (Self.appearance.inputStyle.inputFontColor?.color ?? Self.appearance.colors.textPrimaryShade4.color)
  }
}

struct ExchangeRateLabelView_Previews: PreviewProvider {
  
  static var srcCurrencyIso = "USD"
  static var dstCurrencyIso = "INR"
  @State static var rate = "4.1234"
  @State static var showLoadingIndicator: Bool = false
  
  static var previews: some View {
    ExchangeRateLabelView(srcCurrencyIsoCode: srcCurrencyIso, dstCurrencyIsoCode: dstCurrencyIso, transferRate: $rate)
  }
}
