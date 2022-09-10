//
//  CardDemoView.swift
//  ReadyRemitSDK
//
//  Created by Diego Quimbo on 25/2/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
#if DEBUG

import SwiftUI


struct CardDemoView: View {
  var body: some View {
    VStack() {
      Spacer()
      CardView_Previews.previews
      Spacer()
    }
    .navigationBarTitle("Card Demo")
  }
}

struct CardDemoView_Previews: PreviewProvider {
  static var previews: some View {
    CardDemoView()
  }
}

#endif
