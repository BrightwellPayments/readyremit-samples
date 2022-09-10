//
//  HorizontalTextView.swift
//  HorizontalTextView
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct HorizontalTextView: View, AppearanceConsumer {
  var leftLabel: String = ""
  @Binding var value: String
  var rightLabel: String = ""
  var leftLabelForegroundColor:Color = Self.appearance.colors.textPrimaryShade4.color
  var rightLabelForegroundColor:Color = Self.appearance.colors.textPrimaryShade4.color
  var countryIsoCode: String? = nil
  var currencyIsoCode: String? = nil
  var leftLabelFont: Font {
    let spec = Self.appearance.textfieldSubheadlineFont
    return .font(spec: spec, style: .subheadline)
  }
  var rightLabelFont: Font {
    let spec = Self.appearance.textfieldSubheadlineFont
    return .font(spec: spec, style: .subheadline)
  }
  var isLeftLabelBold: Bool = false
  var isRightLabelBold: Bool = false
  
  var isLeftLabelHighlightRequired: Bool = false
  var isRightLabelHighlightRequired: Bool = false
  var leftLabelHighlightedText: String = "--"
  var rightLabelHighlightedText: String = "--"
  
  var body: some View {
    HStack{
      if isLeftLabelHighlightRequired == false {
        if isLeftLabelBold == false {
          Text(leftLabel).font(leftLabelFont).foregroundColor(leftLabelForegroundColor)
        } else {
          Text(leftLabel).font(leftLabelFont).foregroundColor(leftLabelForegroundColor).bold()
        }
      } else {
        if isLeftLabelBold == false {
          Text(leftLabel).font(leftLabelFont).foregroundColor(leftLabelForegroundColor).hilightedText(str: leftLabel, searched: leftLabelHighlightedText)
        } else {
          Text(leftLabel).font(leftLabelFont).foregroundColor(leftLabelForegroundColor).hilightedText(str: leftLabel, searched: leftLabelHighlightedText).bold()
        }
        
      }
      Spacer()
      if isRightLabelHighlightRequired == false {
        if isRightLabelBold == false {
          Text("\(value) \(rightLabel)")
            .multilineTextAlignment(.trailing)
            .font(rightLabelFont)
            .foregroundColor(rightLabelForegroundColor)
        } else {
          Text("\(value) \(rightLabel)")
            .font(rightLabelFont)
            .foregroundColor(rightLabelForegroundColor)
            .bold()
            .multilineTextAlignment(.trailing)
        }
        
      } else {
        if isRightLabelBold == false {
          Text("\(value) \(rightLabel)")
            .hilightedText(str: rightLabel, searched: rightLabelHighlightedText)
            .multilineTextAlignment(.trailing)
            .font(rightLabelFont)
            .foregroundColor(rightLabelForegroundColor)
            
        } else {
          Text("\(value) \(rightLabel)")
            .hilightedText(str: rightLabel, searched: rightLabelHighlightedText)
            .bold()
            .multilineTextAlignment(.trailing)
            .font(rightLabelFont)
            .foregroundColor(rightLabelForegroundColor)
        }
      }
      if let countryIsoCode = countryIsoCode {
        FlagView(flagImage: FlagImage(countryIso3Code: countryIsoCode))
      } else if let currencyIsoCode = currencyIsoCode {
        FlagView(flagImage: FlagImage(currencyIso3Code: currencyIsoCode))
      }
    }
    .padding(.horizontal, 16)
  }
}

struct HorizontalTextView_Previews: PreviewProvider {
  @State static var value: String = "1"
  static var previews: some View {
    HorizontalTextView(value: $value)
  }
}
