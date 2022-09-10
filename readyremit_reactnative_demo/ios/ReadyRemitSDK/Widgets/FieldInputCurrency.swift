//
//  FieldInputCurrency.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI
import Combine


struct FieldInputCurrency: View, AppearanceConsumer {
  let selection: [Currency]
  @Binding var fieldValue: FieldValue<CurrencyAmountValue>
  @Binding var textInput: String
  @Binding var isLoading: Bool
  @Binding var isDisabled: Bool
  
  @Environment(\.colorScheme) var colorScheme

  init(selection: [Currency], fieldValue: Binding<FieldValue<CurrencyAmountValue>>,
       isLoading: Binding<Bool> = Binding.constant(false), isDisabled: Binding<Bool> = Binding.constant(false)) {
    self.selection = selection
    self._isLoading = isLoading
    self._fieldValue = fieldValue
    if fieldValue.wrappedValue.disabled {
      _state = .init(initialValue: .disabled)
    }
    self._textInput = fieldValue.value.amount
    self._isDisabled = isDisabled
    if fieldValue.value.currency.wrappedValue == nil,
       let firstCurrency = selection.first {
      self.fieldValue.value.currency = firstCurrency
    }
  }

  @State private var state: InputControl.State = .normal
  @State private var showSheet = false
  @State private var dropdownIconHeight: CGFloat = 100

  var body: some View {
    HStack {
      HStack {
        createFlagCurrency()
        Button(action: onCurrencyTap, label: createDropdownImage)
          .disabled(selection.count <= 1)
          .opacity(selection.count <= 1 ? 0 : 1)
      }
      .onTapGesture(perform: onCurrencyTap)
      .font(inputFont)
      .foregroundColor(isDisabled ? disabledColor : inputColor)
      HStack {
        TextField("", text: $textInput, onEditingChanged: editingChanged)
          .keyboardType(.decimalPad)
          .font(inputFont)
          .placeHolder(createPlaceholder(), show: fieldValue.value.amount.isEmpty)
          .foregroundColor(isDisabled ? disabledColor : inputColor)
          .disableAutocorrection(true)
          .onReceive(Just(textInput), perform: cleanupInput)
        Button(action: resetValue, label: createClearButtonImage)
          .opacity((state == .active && !fieldValue.value.amount.isEmpty).double)
          .disabled(fieldValue.value.amount.isEmpty)
      }
    }
    .disabled(isDisabled)
    .onPreferenceChange(HeightPreferenceKey.self,
                        perform: { dropdownIconHeight = $0 })
    .sheet(isPresented: $showSheet,
           onDismiss: onSheetDismiss,
           content: {
      let model = DropdownList<Currency>.Model(title: L10n.rrmSelectCurrencyTitle,
                                               data: selection,
                                               selected: $fieldValue.value.currency)
      DropdownList(model: model)
    })
    .modifier(InputControl(label: fieldValue.fieldReadonlyData.name,
                           required: fieldValue.fieldReadonlyData.required,
                           hideLabel: false,
                           isLineField: true,
                           info: fieldValue.fieldReadonlyData.info ?? "",
                           isLoading: $isLoading,
                           state: $state,
                           validationState: $fieldValue.validation))
    .padding(.horizontal, 16)
  }

  func cleanupInput(_ input: String) {
    guard let currency = fieldValue.value.currency else { return }
    let filtered = currency.cleanupInputString(input)
    if filtered != input {
      textInput = filtered
    }
  }

  func onCurrencyTap() {
    guard selection.count > 1 else { return }
    hideKeyboard()
    state = .active
    showSheet.toggle()
  }

  func onSheetDismiss() { state = .normal }

  func resetValue() {
    fieldValue.value.amount = ""
    _fieldValue.wrappedValue = self.fieldValue
  }

  func editingChanged(_ changed: Bool) { state = changed ? .active : .normal }

  @ViewBuilder func createFlagCurrency() -> some View {
    if let currency = fieldValue.value.currency {
      FlagView(flagImage: FlagImage(currencyIso3Code: currency.iso3Code))
    }
    Text(fieldValue.value.currency?.iso3Code ?? "--")
      .font(currencyFont)
      .background(GeometryReader { reader in
        Color.clear.preference(key: HeightPreferenceKey.self, value: reader.size.height)
      })
  }

  @ViewBuilder func createPlaceholder() -> some View {
    Text("0")
      .font(inputFont)
      .foregroundColor(isDisabled ? disabledColor : placeholderColor)
  }

  @ViewBuilder func createDropdownImage() -> some View {
    Self.appearance.inputStyle.createDropdownIcon(withHeight: dropdownIconHeight)
      .foregroundColor(isDisabled ? disabledColor : dropDownButtonColor)
  }

  @ViewBuilder func createClearButtonImage() -> some View {
    Image(systemName: "x.circle.fill").foregroundColor(isDisabled ? disabledColor : clearButtonColor)
  }

  var currencyFont: Font {
    let spec = Self.appearance.inputStyle.inputFontSpec ?? Self.appearance.inputLabelFont
    return .font(spec: spec, style: .body)
  }
  var inputFont: Font {
    let spec = Self.appearance.inputStyle.inputFontSpec ?? Self.appearance.fonts.title3
    return .font(spec: spec, style: .body)
  }
  var inputColor: Color {
    Self.appearance.colors.textPrimaryShade3.color
  }
  
  var disabledColor: Color {
    Self.appearance.colors.textPrimaryShade1.color
  }

  var placeholderColor: Color {
    Self.appearance.colors.textPrimaryShade2.color
  }

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

struct FieldInputCurrency_Previews : PreviewProvider {
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
        FieldInputCurrency(selection: selections[$0],
                           fieldValue: $model.fieldValues[$0])
      }
    }
    .padding()
    .previewLayout(.sizeThatFits)
    }
  }
}


extension FieldInputCurrency_Previews {

  class Model : ObservableObject {
    @Published var fieldValues: [FieldValue<CurrencyAmountValue>]
    init(fields: [Field]) {
      fieldValues = fields.map {
        FieldValue(field: $0,
                   disabled: $0.id == "id4",
                   value: CurrencyAmountValue())

      }
    }
  }

  static let fields = [
    Field(id: "id1", label: "Currency selector", required: true, placeholder: "0", info: "1 currency"),
    Field(id: "id2", label: "Currency selector", required: true, placeholder: "0", info: "4 currencies"),
    Field(id: "id3", label: "Currency selector", required: true, placeholder: "0", info: "More currencies, searchable"),
    Field(id: "id4", label: "Currency selector", required: false, placeholder: "0", info: "Disabled"),
    Field(id: "id5", label: "Currency selector", required: true, placeholder: "0", info: "Validation ok"),
    Field(id: "id6", label: "Currency selector", required: true, placeholder: "0", info: "Validation fails"),
  ]

  static let selections = [
    [Currency.currencies[0]],
    Array(Currency.currencies[0..<4]),
    Currency.currencies,
    Currency.currencies,
    Currency.currencies,
    Currency.currencies,
  ]
}


#endif
