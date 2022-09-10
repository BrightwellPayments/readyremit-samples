//
//  FromToFlagsView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct FlagToFlagView : View {

  var fromFlag: FlagImage
  var toFlag: FlagImage

  var body: some View {
    HStack {
      FlagView(flagImage: fromFlag)
      Image(systemName: "arrow.right")
      FlagView(flagImage: toFlag)
    }
  }
}


#if DEBUG

struct FlagToFlagView_Previews : PreviewProvider {

  static let fromTo = [
    (FlagImage(countryIso3Code: "JPN"), FlagImage(countryIso3Code: "IDN")),
    (FlagImage(countryIso3Code: "NIC"), FlagImage(countryIso3Code: "UZB")),
    (FlagImage(countryIso3Code: "DNK"), FlagImage(countryIso3Code: "fallback")),
    (FlagImage(countryIso3Code: "fallback"), FlagImage(countryIso3Code: "KWT")),
    (FlagImage(countryIso3Code: "fallback"), FlagImage(countryIso3Code: "fallback")),
  ]

  static var previews: some View {
    VStack(spacing: 8) {
      ForEach(0..<fromTo.count) { 
        FlagToFlagView(fromFlag: fromTo[$0].0, toFlag: fromTo[$0].1)
      }
    }
    .padding()
    .previewLayout(.sizeThatFits)
  }
}

#endif
