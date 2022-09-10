//
//  ButtonsDemoView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
#if DEBUG

import SwiftUI


struct ButtonsDemoView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        HStack() {
          Text("Call-for-Action Buttons")
            .modifier(Title3Text())
            .fixedSize()
            .padding()
        }
        CallforactionButton_previews.previews
      }
    }
    .navigationBarTitle("Buttons")
  }
}

struct ButtonsDemoView_Previews: PreviewProvider {
  static var previews: some View {
    ButtonsDemoView()
  }
}

#endif
