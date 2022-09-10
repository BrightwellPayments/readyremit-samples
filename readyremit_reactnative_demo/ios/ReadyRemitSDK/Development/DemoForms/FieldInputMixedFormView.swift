//
//  FieldInputMixedFormView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import SwiftUI
import Combine


extension FieldInputMixedFormView {

  class Model : ObservableObject {
    var cancellables = Set<AnyCancellable>()
    @Published var fieldValues: [AnyValue]
    @Published var dateValue = FieldValue<DateValue>(field: fields[5], value: DateValue())
    
    init() {
      let fields = FieldInputMixedFormView.fields
      fieldValues = [
        StringValue(field: fields[0], value: "", valueType: .generic),
        PickerFieldValue<Country>(field: fields[1], value: nil),
        FieldValue<CurrencyAmountValue>(field: fields[2], value: CurrencyAmountValue()),
        FieldValue<CountryCallingCodeValue>(field: fields[3], value: CountryCallingCodeValue()),
        FieldValue<DateValue>(field: fields[4], value: DateValue())
      ]
      dateValue.objectWillChange
        .receive(on: RunLoop.main)
        .sink { [weak self] in
          self?.objectWillChange.send() }
        .store(in: &cancellables)
    }
  }
}


struct FieldInputMixedFormView : View {

  @ObservedObject var model: Model
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        ForEach(0..<model.fieldValues.count) { index in
          switch model.fieldValues[index] {
          case _ as StringValue:
            FieldInputText(fieldValue: Binding(get: { model.fieldValues[index] as! StringValue },
                                               set: { model.fieldValues[index] = $0 }))
          case _ as PickerFieldValue<Country>:
            LinePickerField<Country>(selection: Country.countries,
                              fieldValue: Binding(get: {
              model.fieldValues[index] as! PickerFieldValue<Country> },
                                                  set: { model.fieldValues[index] = $0 })) { country in
              country.name
            }
          case _ as FieldValue<CurrencyAmountValue>:
            FieldInputCurrency(selection: Currency.currencies,
                               fieldValue: Binding(get: {
              model.fieldValues[index] as! FieldValue<CurrencyAmountValue> },
                                                   set: { model.fieldValues[index] = $0 }))
          case _ as FieldValue<DateValue>:
            if model.fieldValues[index].fieldReadonlyData.id == "id5" {
              DateField(fieldValue: Binding(get: {
                model.fieldValues[index] as! FieldValue<DateValue>},
                                            set: { model.fieldValues[index] = $0 }))
            }
          case _ as FieldValue<CountryCallingCodeValue>:
            PhoneNumberField(selectedFieldValue: Binding(get: {
              model.fieldValues[index] as! FieldValue<CountryCallingCodeValue> },
                                                         set: { model.fieldValues[index] = $0 }))
          default:
            Text("UNHANDLED")
          }
        }
        DateField(fieldValue: Binding(get: { model.dateValue },
                                      set: { model.dateValue = $0 }),
                  isLineField: false)
        Button(action: validate, label: {Text("Validate")})
          .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
      }
    }
    .onTapGesture { hideKeyboard() }
  }

  func validate() {
    model.fieldValues.forEach {
      switch $0 {
      case let a as StringValue:
        print(a.value)
      case let b as PickerFieldValue<Country>:
        print(String(describing: b.value))
      case let c as FieldValue<CurrencyAmountValue>:
        c.validation = c.value.validate()
      case let d as FieldValue<DateValue>:
        d.validation = d.value.validate()
      case let e as FieldValue<CountryCallingCodeValue>:
        e.validation = e.value.validPhoneNumber
      default:
        print("UNHANDLED")
      }
    }
    model.dateValue.validation = model.dateValue.value.validate()
  }
}


extension FieldInputMixedFormView {
  static let fields = [
    Field(id: "id1", label: "label1", required: true, placeholder: "One", info: "Text Input"),
    Field(id: "id2", label: "label2", required: true, placeholder: "Two", info: "Country Selection"),
    Field(id: "id3", label: "Currency + Amount", required: true, placeholder: "Three", info: "Currency Selection"),
    Field(id: "id4", label: "Phone number", required: true, placeholder: "Four", info: "Country Code Picker and Phone Number Input Field"),
    Field(id: "id5", label: "Date of Birth", required: true, placeholder: "Five", info: "Date Field"),
    Field(id: "id6", label: "Date of Birth", required: true, placeholder: "Six", info: "Date Field")
  ]
}


struct FieldInputMixedFormView_Previews : PreviewProvider {
  static let model = FieldInputMixedFormView.Model()
  static var previews: some View {
    FieldInputMixedFormView(model: model)
  }
}

#endif
