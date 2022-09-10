//
//  MiscellaneousDemoView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import SwiftUI


struct MiscellaneousDemoView: View {

  var body: some View {
    ScrollView {
      VStack {
        HStack {
          Text("Flag Views").modifier(Title3Text()).fixedSize()
          Spacer()
        }
        FlagView_Previews.previews

        HStack {
          Text("Flag to Flag Views").modifier(Title3Text()).fixedSize()
          Spacer()
        }
        FlagToFlagView_Previews.previews
      }
    }
    .navigationBarTitle("Miscellaneous")
    .padding()
  }
}


struct MiscellaneousDemoView_Previews: PreviewProvider {
  static var previews: some View {
    MiscellaneousDemoView()
  }
}

#endif
