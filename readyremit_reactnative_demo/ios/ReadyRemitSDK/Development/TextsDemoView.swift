//
//  TextsDemoView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
#if DEBUG

import SwiftUI


struct TextsDemoView : View {

  var body: some View {
    ScrollView {
      VStack(spacing: 8) {
        HStack {
          Text("Fallback / Base Texts").modifier(Title3Text())
          Spacer()
        }
        HStack {
          VStack(alignment: .leading, spacing: 2) {
            HStack {
              Text("Default").fixedSize()
              Spacer()
            }.padding(.bottom, 8)
            Text("Title 3").modifier(Title3Text())
            Text("Headline").modifier(HeadlineText())
            Text("Body").modifier(BodyText())
            Text("Callout").modifier(CalloutText())
            Text("Subheadline").modifier(SubheadlineText())
            Text("Footnote").modifier(FootnoteText())
            Text("Caption").modifier(CaptionText())
            Spacer()
          }
          Spacer()
          VStack(alignment: .leading, spacing: 2) {
            HStack {
              Text("Emphasis").fixedSize()
              Spacer()
            }.padding(.bottom, 8)
            Text("Title 3").modifier(Title3EmphasisText())
            Text("Headline").modifier(HeadlineEmphasisText())
            Text("Body").modifier(BodyEmphasisText())
            Text("Callout").modifier(CalloutEmphasisText())
            Text("Subheadline").modifier(SubheadlineEmphasisText())
            Text("Footnote").modifier(FootnoteEmphasisText())
            Text("Caption").modifier(CaptionEmphasisText())
            Spacer()
          }
        }
      }
      .padding()
      .navigationBarTitle("Texts", displayMode: .inline)
    }
  }
}


struct TextsDemoView_Previews : PreviewProvider {
  static var previews: some View {
    TextsDemoView()
      .previewLayout(.fixed(width: 300, height: 400))
  }
}

#endif
