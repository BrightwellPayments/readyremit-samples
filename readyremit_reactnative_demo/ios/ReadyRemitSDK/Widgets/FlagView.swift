//
//  FlagView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct FlagView : View {

  let flagImage: FlagImage
  var height: CGFloat = 24
  var width: CGFloat = 32

  var body: some View {
    Image(uiImage: flagImage.image)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: width, height: height)
      .cornerRadius(2)
      .clipped()
      .overlay(
        RoundedRectangle(cornerRadius: 2).stroke(Color.gray.opacity(0.3))
      )
  }
}


#if DEBUG

struct FlagView_Previews : PreviewProvider {
  static let flags = [ FlagImage(countryIso3Code: "JPN"),
                       FlagImage(countryIso3Code: "FIN"),
                       FlagImage(countryIso3Code: "MUS"),
                       FlagImage(countryIso3Code: "fallback") ]

  static var previews: some View {
    VStack {
      ForEach(0..<flags.count) {
        FlagView(flagImage: flags[$0])
      }
    }
    .padding()
    .background(Color.white)
  }
}

#endif
