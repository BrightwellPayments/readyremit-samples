//
//  CurrencyFieldsDemoView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import SwiftUI


struct CurrencyFieldsDemoView: View {
  var body: some View {
    ScrollView {
      FieldInputCurrencyFormView(
        model: FieldInputCurrency_Previews.Model(fields: Array(FieldInputCurrency_Previews.fields[0..<4]))
      )
    }
    .padding(.top, 16)
    .onTapGesture { hideKeyboard() }
    .navigationBarTitle("Currency Dropdowns")
  }
}


struct FieldInputCurrencyFormView: View {

  @ObservedObject var model: FieldInputCurrency_Previews.Model

  var body: some View {
    VStack(spacing: 24) {
      ForEach(0..<model.fieldValues.count) { index in
        FieldInputCurrency(selection: FieldInputCurrency_Previews.selections[index],
                           fieldValue: Binding(get: { model.fieldValues[index] },
                                               set: { model.fieldValues[index] = $0 }))
      }
      Button(action: validate,
             label: { Text("Validate") })
    }
  }

  func validate() {
    model.fieldValues.forEach {
      print("\($0.value.currency?.name ?? "nil currency") -- \($0.value.amount)")
      switch $0.fieldReadonlyData.id {
      case "id2": $0.validation = .success
      case "id3": $0.validation = .fail(["Failed to validate"])
      default: ()
      }
    }
    model.objectWillChange.send()
  }
}


struct CurrencyFieldsDemoView_Previews: PreviewProvider {
  static var previews: some View {
    CurrencyFieldsDemoView()
  }
}

#endif
