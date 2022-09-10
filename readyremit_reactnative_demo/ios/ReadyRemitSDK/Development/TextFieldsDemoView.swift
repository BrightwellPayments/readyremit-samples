//
//  TextFieldsDemoView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import SwiftUI


struct TextFieldsDemoView: View {

  var body: some View {
    ScrollView {
      FieldInputTextFormView(
        model: FieldInputTextFormView.FormModel(fields: FieldInputTextFormView.fields)
      )
    }
    .onTapGesture { hideKeyboard() }
    .navigationBarTitle("Text Inputs")
  }
}


struct TextFieldsDemoView_Previews: PreviewProvider {
  static var previews: some View {
    TextFieldsDemoView()
  }
}

#endif
