//
//  InputText.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI
import Combine


struct FieldInputText : View, AppearanceConsumer {

  @Binding var fieldValue: StringValue
  @Binding var textInput: String
  @Environment(\.colorScheme) var colorScheme

  internal init(fieldValue: Binding<StringValue>) {
    self._fieldValue = fieldValue
    self._textInput = fieldValue.value
    if fieldValue.wrappedValue.disabled {
      _state = .init(initialValue: .disabled)
    }
  }

  @State private var state: InputControl.State = .normal

  var body: some View {
    HStack {
      TextField("",
                text: $textInput,
                onEditingChanged: editingChanged
      )
        .placeHolder(createPlaceholder(), show: state != .active && fieldValue.value.isEmpty)
        .font(inputFont)
        .foregroundColor(state == .disabled ? disabledColor : textColor)
        .disableAutocorrection(true)
        .onReceive(Just(textInput), perform: filterInput)
      Button(action: resetValue,
             label: createButtonImage)
        .opacity((state == .active && !fieldValue.value.isEmpty).double)
        .disabled(fieldValue.value.isEmpty)
    }
    .disabled(state == .disabled)
    .modifier(InputControl(label: fieldValue.fieldReadonlyData.placeholder,
                           required: fieldValue.fieldReadonlyData.required,
                           hideLabel: state != .active && fieldValue.value.isEmpty,
                           isLineField: true,
                           info: fieldValue.fieldReadonlyData.info ?? "",
                           state: $state,
                           validationState: $fieldValue.validation))
    .padding(.horizontal, 16)
  }

  @ViewBuilder func createButtonImage() -> some View {
    Image(systemName: "x.circle.fill").foregroundColor(buttonColor)
  }

  @ViewBuilder func createPlaceholder() -> some View {
    Text(fieldValue.fieldReadonlyData.requiredPlaceholder)
      .foregroundColor(state == .disabled ? disabledColor : placeholderColor)
      .font(placeholderFont)
  }
  
  func resetValue() {
    fieldValue.value = ""
    _fieldValue.wrappedValue = self.fieldValue
  }

  func editingChanged(_ changed: Bool) { state = changed ? .active : .normal }
  
  func filterInput(_ input: String) {
    let filtered = fieldValue.filterInput(input)
    if input != filtered {
      textInput = filtered
    }
  }

  var inputFont: Font {
    let spec = Self.appearance.inputStyle.inputFontSpec ?? Self.appearance.fonts.callout
    return .font(spec: spec, style: .callout)
  }
  var textColor: Color {
    Self.appearance.colors.textPrimaryShade3.color
  }
  var disabledColor: Color {
    Self.appearance.colors.textPrimaryShade1.color
  }
  var placeholderFont: Font {
    let spec = Self.appearance.inputStyle.placeholderFontSpec ?? Self.appearance.fonts.callout
    return .font(spec: spec, style: .callout)
  }
  
  var placeholderColor: Color {
    Self.appearance.colors.textPrimaryShade2.color
  }

  var buttonColor: Color {
    Self.appearance.inputStyle.buttonDeleteColor?.color
    ?? Self.appearance.colors.controlAccessoryShade2.color
  }
}


#if DEBUG

struct FieldInputText_Previews: PreviewProvider {
  static let fields = [
    Field(id: "id1", label: "one", required: true, placeholder: "One", info: "empty"),
    Field(id: "id2", label: "two", required: true, placeholder: "Two", info: "Validation ok"),
    Field(id: "id3", label: "three", required: true, placeholder: "Three", info: "Validation fails"),
    Field(id: "id4", label: "four", required: true, placeholder: "Four", info: "Disabled")
  ]
  static let values = ["", "valid value", "invalid value"]
  static let validations = [ValidationResult.none,
                            .success,
                            .fail(["Too long", "Invalid characters"])]

  @ObservedObject static var model: FieldInputTextFormView.FormModel = {
    let model = FieldInputTextFormView.FormModel(fields: fields)
    for i in 0...2 {
      model.fieldValues[i].value = values[i]
      model.fieldValues[i].validation = validations[i]
    }
    return model
  }()

  @State static var fieldValues: [StringValue] = fields.enumerated().map {
    StringValue(field: $0.1,
               disabled: $0.0 == 4,
               value: values[$0.0],
                validation: validations[$0.0],
                valueType: .generic)
  }

  static var previews: some View {
    VStack(spacing: 24) {
      ForEach(0..<model.fieldValues.count) {
        FieldInputText(fieldValue: $model.fieldValues[$0])
      }
      Button("Validate", action: {
        model.validate()
      })
    }.padding().previewLayout(.sizeThatFits)
  }
}

#endif
