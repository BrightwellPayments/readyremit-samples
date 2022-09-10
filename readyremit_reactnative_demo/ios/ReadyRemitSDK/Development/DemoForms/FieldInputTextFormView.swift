//
//  FieldInputTextFormView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import SwiftUI


extension FieldInputTextFormView {

  class FormModel : ObservableObject {

    @Published var fieldValues: [StringValue]

    init(fields: [Field]) {
      fieldValues = fields.map { StringValue(field: $0,
                                             disabled: $0.id == "id4",
                                             value: "",
                                             valueType: .generic) }
    }

    func validate() {
      fieldValues[0].validation = .none
      fieldValues[1].validation = .fail(["Thing too long", "Thing contains invalid characters"])
      fieldValues[2].validation = .success
      fieldValues[3].validation = .none
      self.objectWillChange.send()
    }
  }
}


struct FieldInputTextFormView : View {

  @ObservedObject var model: FormModel

  var body: some View {
    VStack(spacing: 16) {
      ForEach(0..<model.fieldValues.count) { index in
        FieldInputText(fieldValue: Binding(get: { model.fieldValues[index] },
                                           set: { model.fieldValues[index] = $0 }))
      }
      Spacer()
      Button("Validate", action: buttonTap)
    }
    .padding()
  }

  func buttonTap() {
    hideKeyboard()
    model.validate()
  }
}


extension FieldInputTextFormView {

  static let fields = [
    Field(id: "id1", label: "label1", required: false, placeholder: "One", info: "No validation"),
    Field(id: "id2", label: "label2", required: true, placeholder: "Two", info: "Fails validation"),
    Field(id: "id3", label: "label3", required: true, placeholder: "Three", info: "Validates ok"),
    Field(id: "id4", label: "label4", required: false, placeholder: "Four", info: "Disabled")
  ]
}


struct FieldInputTextFormView_Previews : PreviewProvider {

  static let fields = FieldInputTextFormView.fields

  static var previews: some View {
    FieldInputTextFormView(model: FieldInputTextFormView.FormModel(fields: fields))
  }
}

#endif
