//
//  LinePickerField.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct LinePickerField<T>: View, AppearanceConsumer
where T: Identifiable & Filterable & ListRowProvider {

  @Environment(\.colorScheme) var colorScheme
  var selection: [T]
  @Binding var fieldValue: PickerFieldValue<T>
  @Binding var isLoading: Bool
  let textToDisplay: (T) -> String

  internal init(
    selection: [T],
    fieldValue: Binding<PickerFieldValue<T>>,
    isLoading: Binding<Bool> = Binding.constant(false),
    textToDisplay: @escaping (T) -> String) {
    self.selection = selection
    self.textToDisplay = textToDisplay
    self._isLoading = isLoading
    self._fieldValue = fieldValue
    if fieldValue.wrappedValue.disabled {
      _state = .init(initialValue: .disabled)
    }
    if self.fieldValue.value == nil,
       selection.count == 1,
       let firstSelection = selection.first {
      self.fieldValue.value = firstSelection
    }
  }

  @State private var state: InputControl.State = .normal
  @State private var showSheet = false
  @State var dropdownIconHeight: CGFloat = 100

  var body: some View {
    HStack {
      createInputText()
        .background(GeometryReader { reader in
          Color.clear.preference(key: HeightPreferenceKey.self, value: reader.size.height)
        })
      Spacer()
      Button(action: onTap, label: createDropdownImage)
    }
    .onPreferenceChange(HeightPreferenceKey.self, perform: { dropdownIconHeight = $0 })
    .background(Color.tappable)
    .onTapGesture { onTap() }
    .disabled(state == .disabled)
    .sheet(isPresented: $showSheet,
           onDismiss: { state = .normal },
           content: {
      let model = DropdownList<T>.Model(title: fieldValue.fieldReadonlyData.name,
                                              data: selection,
                                              selected: $fieldValue.value)
      DropdownList(model: model)
    })
    .modifier(InputControl(label: fieldValue.fieldReadonlyData.name,
                           required: fieldValue.fieldReadonlyData.required,
                           hideLabel: fieldValue.value == nil,
                           isLineField: true,
                           info: fieldValue.fieldReadonlyData.info ?? "",
                           isLoading: $isLoading,
                           state: $state,
                           validationState: $fieldValue.validation))
    .padding(.horizontal, 16)
  }

  @ViewBuilder func createInputText() -> some View {
    if let value = fieldValue.value {
      Text(textToDisplay(value))
        .font(inputFont)
        .foregroundColor(inputColor)
    } else {
      Text(fieldValue.fieldReadonlyData.requiredPlaceholder)
        .font(placeholderFont)
        .foregroundColor(placeholderColor)
    }
  }

  @ViewBuilder func createDropdownImage() -> some View  {
    if selection.count > 1 {
      Self.appearance.inputStyle.createDropdownIcon(withHeight: dropdownIconHeight)
        .foregroundColor(buttonDropdownColor)
    }
  }

  var inputFont: Font {
    let spec = Self.appearance.fonts.callout
    return .font(spec: spec, style: .callout)
  }
  var inputColor: Color { Self.appearance.colors.primaryShade1.color }
  var buttonDropdownColor: Color { Self.appearance.colors.controlAccessoryShade2.color }
  var placeholderColor: Color { Self.appearance.colors.textPrimaryShade2.color }
  var placeholderFont: Font {
    let spec = Self.appearance.fonts.callout
    return .font(spec: spec, style: .callout)
  }

  func onTap() {
    if selection.count <= 1 {
      return
    }
    state = .active
    showSheet.toggle()
  }
}


#if DEBUG

struct InputField_Previews: PreviewProvider {

  static let validations = [ValidationResult.none,
                            .success,
                            .fail(["Too long", "Invalid characters"])]

  @ObservedObject static var model: Model = {
    let model = Model(fields: fields)
    for i in 0...2 {
      model.fieldValues[i].value = nil
      model.fieldValues[i].validation = validations[i]
    }
    return model
  }()

  static var previews: some View {
    VStack(spacing: 24) {
      ForEach(0..<model.fieldValues.count) {
        LinePickerField(selection: Country.countries,
                             fieldValue: $model.fieldValues[$0],
                             textToDisplay: textToDisplay)
      }
    }.padding().previewLayout(.sizeThatFits)
  }
  
  private static func textToDisplay(value: Country) -> String {
    return value.name
  }
}


extension InputField_Previews {

  class Model : ObservableObject {
    @Published var fieldValues: [PickerFieldValue<Country>]
    init(fields: [Field]) {
      fieldValues = fields.map {
        PickerFieldValue(field: $0,
                     disabled: $0.id == "id5",
                     value: nil)
      }
      fieldValues[1].validation = .success
      fieldValues[2].validation = .fail(["Too long", "Invalid characters"])
    }
  }

  static let fields = [
    Field(id: "id1", label: "country1", required: false, placeholder: "One", info: "1 country"),
    Field(id: "id2", label: "country2", required: true, placeholder: "Two", info: "4 countries"),
    Field(id: "id3", label: "country3", required: true, placeholder: "Three", info: "9 countries"),
    Field(id: "id4", label: "country4", required: false, placeholder: "Four", info: "12+ countries Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32.  The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham."),
    Field(id: "id5", label: "country5", required: false, placeholder: "Five", info: "Disabled"),
  ]

  static let countrySelections: [[Country]] = [
    [Country.countries[0]],
    Array(Country.countries[0..<4]),
    Array(Country.countries[0..<9]),
    Country.countries,
    Country.countries,
  ]
}

#endif
