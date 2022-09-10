//
//  DateField.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 3/16/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI
import Combine


struct DateField: View, AppearanceConsumer {
  
  @Environment(\.colorScheme) var colorScheme
  @State private var dropdownIconHeight: CGFloat = 100
  @State private var state: InputControl.State = .normal
  @Binding var validationState: ValidationResult
  @State private var showSheet = false
  let isLineField: Bool
  
  @Binding var fieldValue: FieldValue<DateValue>
  private var selection = [Month]()
  private let months = Calendar.current.monthSymbols
  
  internal init(fieldValue: Binding<FieldValue<DateValue>>, isLineField: Bool = true) {
    self.isLineField = isLineField
    self._fieldValue = fieldValue
    self._validationState = fieldValue.validation
    for month in months {
      self.selection.append(Month(name: month))
    }
  }
  
  var body: some View {
    HStack(alignment: .bottom, spacing: 16) {
      VStack(alignment: .leading, spacing: 4) {
        if !isLineField {
          Text(L10n.rrmCommonMonth)
            .foregroundColor(dateSectionLabelColor)
            .font(dateSectionLabelFont)
        }
        HStack {
          createMonthText()
            .background(GeometryReader { reader in
              Color.clear.preference(key: HeightPreferenceKey.self, value: reader.size.height)
            })
          Spacer()
          Button(action: onMonthTap, label: createDropdownImage)
            .padding(.trailing, 8)
        }
        .padding(.leading, 14)
        .frame(height: isLineField ? 25 : 44)
        .border(borderColor, width: isLineField ? 0 : 1)
        
        if isLineField {
          Rectangle()
            .fill(borderColor)
            .frame(height: borderWidth)
        }
      }
      .onTapGesture(perform: onMonthTap)
      .font(inputFont)
      .foregroundColor(inputColor)
      
      DateTextField(isLineField: isLineField,
                    type: .day,
                    title: L10n.rrmCommonDay,
                    inputText: $fieldValue.value.day,
                    validationState: $fieldValue.validation)
      .frame(width: 56)
      
      DateTextField(isLineField: isLineField,
                    type: .year,
                    title: L10n.rrmCommonYear,
                    inputText: $fieldValue.value.year,
                    validationState: $fieldValue.validation)
      .frame(width: 81)
    }
    .disabled(state == .disabled)
    .sheet(isPresented: $showSheet,
           onDismiss: onSheetDismiss,
           content: {
      let model = DropdownList<Month>.Model(title: L10n.rrmCommonMonth,
                                            data: selection,
                                            selected: $fieldValue.value.month)
      DropdownList(model: model) })
    .onPreferenceChange(HeightPreferenceKey.self,
                        perform: { dropdownIconHeight = $0 })
    .modifier(InputControl(label: fieldValue.fieldReadonlyData.name,
                           required: fieldValue.fieldReadonlyData.required,
                           hideLabel: false,
                           isLineField: false,
                           info: fieldValue.fieldReadonlyData.info ?? "",
                           state: $state,
                           validationState: $fieldValue.validation))
    .padding(.horizontal, 16)
  }
  
  @ViewBuilder func createMonthText() -> some View {
    if let monthName = fieldValue.value.month?.name {
      Text(monthName)
        .font(inputFont)
        .foregroundColor(inputColor)
    } else {
      Text(L10n.rrmDropdownPlaceholder)
        .font(placeholderFont)
        .foregroundColor(placeholderColor)
    }
  }
  
  @ViewBuilder func createDropdownImage() -> some View {
    Self.appearance.inputStyle.createDropdownIcon(withHeight: dropdownIconHeight)
      .foregroundColor(dropDownButtonColor)
  }
  
  func editingChanged(_ changed: Bool) { state = changed ? .active : .normal }
  
  func onMonthTap() {
    hideKeyboard()
    state = .active
    showSheet.toggle()
  }
  
  func onSheetDismiss() { state = .normal }
  
  func resetDay() { fieldValue.value.day = "" }
  
  func resetYear() { fieldValue.value.year = "" }
  
  var inputFont: Font {
    let spec = Self.appearance.inputStyle.inputFontSpec ?? Self.appearance.fonts.callout
    return .font(spec: spec, style: .callout)
  }
  var inputColor: Color { state.mainTextColor }
  var dateSectionLabelColor: Color {
    Self.appearance.inputStyle.dateLabelColor?.color
    ?? ((colorScheme == .light) ? Self.appearance.colors.textPrimaryShade2.color : Self.appearance.colors.textPrimaryShade3.color)
  }
  var dateSectionLabelFont: Font {
    let spec = Self.appearance.inputStyle.dateLabelFontSpec ?? Self.appearance.fonts.subheadline
    return .font(spec: spec, style: .subheadline)
  }
  var borderColor: Color { validationState == .none ? state.borderColor : validationState.borderColor }
  var borderWidth: CGFloat {
    switch state {
    case .active: return Self.appearance.inputStyle.borderWidthActivated ?? 2
    case .normal, .disabled: return Self.appearance.inputStyle.borderWidth ?? 1
    }
  }
  var dropDownButtonColor: Color {
    Self.appearance.inputStyle.buttonDropdownColor?.color ?? Self.appearance.colors.controlAccessoryShade1.color
  }
  var placeholderFont: Font {
    let spec = Self.appearance.inputStyle.placeholderFontSpec ?? Self.appearance.fonts.callout
    return .font(spec: spec, style: .callout)
  }
  var placeholderColor: Color { state.placeholderTextColor(colorScheme: colorScheme) }
}


struct DateTextField: View, AppearanceConsumer {
  
  @Environment(\.colorScheme) var colorScheme
  let isLineField: Bool
  let type: Calendar.Component
  let title: String
  @Binding var inputText: String
  @Binding var validationState: ValidationResult
  @State private var state: InputControl.State = .normal
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      if !isLineField {
        HStack {
          Text(title)
            .foregroundColor(labelColor)
            .font(labelFont)
        }
      }
      HStack {
        TextField("", text: $inputText, onEditingChanged: editingChanged)
          .keyboardType(.decimalPad)
          .font(inputFont)
          .foregroundColor(inputColor)
          .padding(.leading, 12)
          .placeHolder(createPlaceholder(),
                       show: inputText.isEmpty && state != .active)
          .disableAutocorrection(true)
          .onReceive(Just(inputText), perform: cleanupInput)
      }
      .frame(height: isLineField ? 25 : 44)
      .border(borderColor, width: isLineField ? 0 : 1)
      
      if isLineField {
        Rectangle()
          .fill(borderColor)
          .frame(height: borderWidth)
      }
    }
  }
  
  @ViewBuilder func createPlaceholder() -> some View {
    if type == .day {
      Text(L10n.rrmCommonDay)
        .padding(.leading, 8)
        .font(placeholderFont)
        .foregroundColor(placeholderColor)
    } else if type == .year {
      Text("YYYY")
        .padding(.leading, 8)
        .font(placeholderFont)
        .foregroundColor(placeholderColor)
    }
  }
  
  @ViewBuilder func createClearButtonImage() -> some View {
    Image(systemName: "x.circle.fill")
      .foregroundColor(clearButtonColor)
  }
  
  func editingChanged(_ changed: Bool) { state = changed ? .active : .normal }
  
  func cleanupInput(_ input: String) {
    let allowed = "0123456789"
    var filtered = input.filter {
      allowed.contains($0)
    }
    if type == .day {
      filtered = String(filtered.prefix(Constants.dayMaxLength))
      if let day = Int(filtered), day > DateValue.maxDay {
        filtered.removeLast()
      }
    } else if type == .year {
      filtered = String(filtered.prefix(Constants.yearMaxLength))
      if let year = Int(filtered), year > DateValue.maxYear {
        filtered.removeLast()
      }
    }
    if inputText != filtered {
      inputText = filtered
    }
  }
  
  var labelColor: Color {
    Self.appearance.inputStyle.dateLabelColor?.color
    ?? ((colorScheme == .light) ? Self.appearance.colors.textPrimaryShade2.color : Self.appearance.colors.textPrimaryShade3.color)
  }
  var labelFont: Font {
    let spec = Self.appearance.inputStyle.dateLabelFontSpec ?? Self.appearance.fonts.subheadline
    return .font(spec: spec, style: .subheadline)
  }
  var inputColor: Color { state.mainTextColor }
  var inputFont: Font {
    let spec = Self.appearance.inputStyle.inputFontSpec ?? Self.appearance.fonts.body
    return .font(spec: spec, style: .body)
  }
  var borderWidth: CGFloat {
    switch state {
    case .active: return Self.appearance.inputStyle.borderWidthActivated ?? 2
    case .normal, .disabled: return Self.appearance.inputStyle.borderWidth ?? 1
    }
  }
  var borderColor: Color { validationState == .none ? state.borderColor : validationState.borderColor }
  var placeholderFont: Font {
    let spec = Self.appearance.inputStyle.placeholderFontSpec ?? Self.appearance.fonts.callout
    return .font(spec: spec, style: .callout)
  }
  var placeholderColor: Color { state.placeholderTextColor(colorScheme: colorScheme) }
  var clearButtonColor: Color { Self.appearance.inputStyle.buttonDeleteColor?.color ?? Self.appearance.colors.controlAccessoryShade1.color }
}
