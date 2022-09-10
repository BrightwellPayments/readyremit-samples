//
//  CountryFieldsDemoView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import SwiftUI


struct CountryFieldsDemoView: View {

  var body: some View {
    ScrollView {
      FieldInputCountryFormView(
        model: InputField_Previews.Model(fields: InputField_Previews.fields)
      )
    }
    .padding(.top, 16)
    .onTapGesture { hideKeyboard() }
    .navigationBarTitle("Country Dropdowns")
  }
}


struct FieldInputCountryFormView: View {

  @ObservedObject var model: InputField_Previews.Model

  var body: some View {
    VStack(spacing: 24) {
      ForEach(0..<model.fieldValues.count) { index in
        LinePickerField(selection: InputField_Previews.countrySelections[index],
                             fieldValue: Binding(get: { model.fieldValues[index] },
                                                 set: { model.fieldValues[index] = $0 })) { country in
          country.name
        }
      }
    }
  }
}


struct CountryFieldsDemoView_Previews: PreviewProvider {

  static var previews: some View {
    CountryFieldsDemoView()
  }
}

#endif
