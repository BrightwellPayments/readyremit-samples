//
//  PhoneNumberField.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 3/15/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation
import SwiftUI
import Combine


struct PhoneNumberField: View, AppearanceConsumer {
  
  @Environment(\.colorScheme) var colorScheme
  var selection: [CountryCallingCode]
  @Binding var selectedFieldValue: FieldValue<CountryCallingCodeValue>
  @Binding var textInput: String
  @State private var state: InputControl.State = .normal
  @State private var showSheet = false
  @State private var dropdownIconHeight: CGFloat = 100
  
  init(selection: [CountryCallingCode] = Bundle.sdk.decodeJson([CountryCallingCode].self, from: "CountryCallingCodes"), selectedFieldValue: Binding<FieldValue<CountryCallingCodeValue>>) {
    
    self.selection = selection
    self._selectedFieldValue = selectedFieldValue
    if selectedFieldValue.wrappedValue.disabled {
      _state = .init(initialValue: .disabled)
    }
    self._textInput = selectedFieldValue.value.phoneNumber
    if selectedFieldValue.value.countryCallingCode.wrappedValue == nil {
      if selection.count > 1 {
        selectedFieldValue.value.countryCallingCode.wrappedValue = selection.first(where: { $0.iso3Code == "USA"})
      }else{
        selectedFieldValue.value.countryCallingCode.wrappedValue = selection[0]
      }
    }
  }
  
  var body: some View {
    HStack {
      HStack {
        createFlag()
        Button(action: onDropdownTap, label: createDropdownImage)
          .disabled(selection.count <= 1)
          .opacity(selection.count <= 1 ? 0 : 1)
      }
      .onTapGesture(perform: onDropdownTap)
      .font(inputFont)
      .foregroundColor(inputColor)
      
      TextField("0", text: $textInput, onEditingChanged: editingChanged)
        .keyboardType(.decimalPad)
        .font(inputFont)
        .foregroundColor(inputColor)
        .disableAutocorrection(true)
        .onReceive(Just(textInput), perform: cleanupInput)
      Button(action: resetValue, label: createClearButtonImage)
        .opacity((state == .active && !selectedFieldValue.value.phoneNumber.isEmpty).double)
        .disabled(selectedFieldValue.value.phoneNumber.isEmpty)
    }
    .disabled(state == .disabled)
    .onPreferenceChange(HeightPreferenceKey.self,
                        perform: { dropdownIconHeight = $0 })
    .sheet(isPresented: $showSheet,
           onDismiss: onSheetDismiss,
           content: {
      let model = DropdownList<CountryCallingCode>.Model(title: L10n.rrmSelectCountryCallingCodeTitle,
                                               data: selection,
                                               selected: $selectedFieldValue.value.countryCallingCode)
      DropdownList(model: model)
    })
    .modifier(InputControl(label: selectedFieldValue.fieldReadonlyData.name,
                           required: selectedFieldValue.fieldReadonlyData.required,
                           hideLabel: false,
                           isLineField: true,
                           info: selectedFieldValue.fieldReadonlyData.info ?? "",
                           state: $state,
                           validationState: $selectedFieldValue.validation))
    .padding(.horizontal, 16)
  }
  
  func onDropdownTap() {
    guard selection.count > 1 else { return }
    hideKeyboard()
    state = .active
    showSheet.toggle()
  }
  
  func resetValue() {
    selectedFieldValue.value.phoneNumber = ""
    _selectedFieldValue.wrappedValue = self.selectedFieldValue
  }
  
  func cleanupInput(_ input: String) {
    let allowed = "0123456789-"
    var filtered = input.filter {
      allowed.contains($0)
    }
    filtered = String(filtered.prefix(Constants.maxPhoneNumberLength))
    if input != filtered {
      textInput = filtered
    }
  }
  
  func onSheetDismiss() { state = .normal }
  
  func editingChanged(_ changed: Bool) { state = changed ? .active : .normal }
  
  @ViewBuilder func createFlag() -> some View {
    if let countryCallingCode = selectedFieldValue.value.countryCallingCode {
      FlagView(flagImage: FlagImage(countryIso3Code: countryCallingCode.iso3Code))
    }
    Text("+" + (selectedFieldValue.value.countryCallingCode?.callingCode ?? "00"))
      .font(countryCodeFont)
      .background(GeometryReader { reader in
        Color.clear.preference(key: HeightPreferenceKey.self, value: reader.size.height)
      })
  }
  
  @ViewBuilder func createPlaceholder() -> some View {
    Text("0")
      .font(inputFont)
      .foregroundColor(placeholderColor)
  }
  
  @ViewBuilder func createDropdownImage() -> some View {
    Self.appearance.inputStyle.createDropdownIcon(withHeight: dropdownIconHeight)
      .foregroundColor(dropDownButtonColor)
  }
  
  @ViewBuilder func createClearButtonImage() -> some View {
    Image(systemName: "x.circle.fill").foregroundColor(clearButtonColor)
  }
  
  var countryCodeFont: Font {
    let spec = Self.appearance.inputStyle.inputFontSpec ?? Self.appearance.inputLabelFont
    return .font(spec: spec, style: .body)
  }
  var inputFont: Font {
    let spec = Self.appearance.inputStyle.inputFontSpec ?? Self.appearance.fonts.title3
    return .font(spec: spec, style: .body)
  }
  var inputColor: Color { Self.appearance.colors.textPrimaryShade3.color }
  var placeholderColor: Color { Self.appearance.colors.textPrimaryShade2.color }
  var clearButtonColor: Color {
    Self.appearance.inputStyle.buttonDeleteColor?.color
      ?? Self.appearance.colors.controlAccessoryShade1.color
  }
  var dropDownButtonColor: Color {
    Self.appearance.inputStyle.buttonDropdownColor?.color
    ?? Self.appearance.colors.controlAccessoryShade1.color
  }
}


#if DEBUG

struct PhoneNumberField_Previews : PreviewProvider {
  @ObservedObject static var model: Model = {
    let model = Model(fields: fields)
    for i in 0..<model.fieldValues.count {
      switch i {
      case 4:
        model.fieldValues[i].validation = ValidationResult.success
      case 5:
        model.fieldValues[i].validation = ValidationResult.fail(["Incorrect"])
      default: ()
      }
    }
    return model
  }()
  
  static var previews: some View {
    NavigationView {
      VStack(spacing: 24) {
        ForEach(0..<model.fieldValues.count) {
          PhoneNumberField(selectedFieldValue: $model.fieldValues[$0])
        }
      }
      .previewLayout(.sizeThatFits)
    }
  }
  
  class Model : ObservableObject {
    @Published var fieldValues: [FieldValue<CountryCallingCodeValue>]
    init(fields: [Field]) {
      fieldValues = fields.map {
        FieldValue(field: $0, disabled: $0.id == "id4", value: CountryCallingCodeValue())
      }
    }
  }
  
  static let fields = [
    Field(id: "id1", label: "Phone selector", required: true, placeholder: "0", info: "phone number"),
    Field(id: "id2", label: "Phone selector", required: true, placeholder: "0", info: "phone number"),
    Field(id: "id3", label: "Phone selector", required: true, placeholder: "0", info: "phone number"),
    Field(id: "id4", label: "Phone selector", required: false, placeholder: "0", info: "Disabled"),
    Field(id: "id5", label: "Phone selector", required: true, placeholder: "0", info: "Validation ok"),
    Field(id: "id6", label: "Phone selector", required: true, placeholder: "0", info: "Validation fails"),
  ]
}

#endif
