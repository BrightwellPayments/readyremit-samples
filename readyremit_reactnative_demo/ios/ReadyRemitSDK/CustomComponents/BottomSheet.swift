//
//  BottomSheet.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 4/12/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI


struct BottomSheet: ViewModifier, AppearanceConsumer {
  
  enum SheetSize {
    case small, medium, large
  }
  
  @Environment(\.presentationMode) var presentation
  var sheetSize: SheetSize
  let title: String?
  var labelAction: (label: String, action: () -> ())? = nil
  
  func body(content: Content) -> some View {
    VStack {
      Spacer()
      VStack {
        if title != nil || labelAction != nil {
          VStack {
            HStack {
              if let title = title {
                Text(title)
                  .foregroundColor(titleColor)
              }
              Spacer()
              if let action = labelAction?.action,
                 (labelAction?.label != nil) {
                Button(action: action, label: actionButton)
              }
            }
            .font(titleFont)
            Divider()
          }
        }
        content
      }
      .padding()
      .background(backgroundColor)
      .cornerRadius(8)
      .modifier(Height(height: listHeight))
    }
    .background(DynamicSizeSheetBackgroundView().onTapGesture(perform: dismiss))
    .edgesIgnoringSafeArea(.all)
  }
  
  @ViewBuilder func actionButton() -> some View {
    Text(labelAction?.label ?? "").foregroundColor(actionButtonColor)
  }
  
  func dismiss() {
    presentation.wrappedValue.dismiss()
  }
  
  var listHeight: CGFloat? {
    switch  sheetSize {
    case .small:
      return UIScreen.main.bounds.height * 1 / 4
    case .medium:
      return UIScreen.main.bounds.height * 3 / 5
    case .large:
      return UIScreen.main.bounds.height * 4 / 5
    }
  }
  var actionButtonColor: Color {
    Self.appearance.dropdownListStyle.backButtonColor?.color
    ?? Self.appearance.colors.primaryShade1.color
  }
  var titleFont: Font {
    let spec = Self.appearance.dropdownListStyle.titleFontSpec
    ?? Self.appearance.fonts.title3
    return .font(spec: spec, style: .headline)
  }
  var titleColor: Color {
    Self.appearance.dropdownListStyle.titleFontColor?.color
    ?? Self.appearance.colors.textPrimaryShade4.color
  }
  var backgroundColor: Color {
    Self.appearance.dropdownListStyle.backgroundColor?.color
    ?? Self.appearance.colors.backgroundColorPrimary.color
  }
}


struct BottomInfoSheet: View, AppearanceConsumer {

  @Environment(\.colorScheme) var colorScheme
  var sheetSize: BottomSheet.SheetSize
  let title: String?
  var labelAction: (label: String, action: () -> ())? = nil
  let info: String?
  
  var body: some View {
    VStack {
      if let info = info {
        ScrollView {
          HStack(alignment: .top, spacing: 12) {
            createInfoIcon()
              .foregroundColor(infoIconColor)
            Text(info)
              .font(infoFont)
              .foregroundColor(infoForegroundColor)
            Spacer()
          }
        }
      }
    }.modifier(BottomSheet(sheetSize: sheetSize,
                           title: title,
                           labelAction: labelAction))
  }
  
  func createInfoIcon() -> Image {
    if let uiImage = Self.appearance.inputStyle.infoIcon {
      return Image(uiImage: uiImage)
    }
    return Image(systemName: "info.circle")
  }

  var infoIconColor: Color {
    (colorScheme == .light) ?
    Self.appearance.colors.inputUnderLineActive.light.color : Self.appearance.colors.inputUnderLineActive.dark.color
  }
  var infoFont: Font {
    let spec = Self.appearance.inputStyle.infoFontSpec ?? Self.appearance.fonts.footnote
    return .font(spec: spec, style: .footnote)
  }
  var infoForegroundColor: Color {
    Self.appearance.inputStyle.infoFontColor?.color ??
    Self.appearance.colors.textPrimaryShade4.color
  }
}


struct BottomSelectionSheet<T>: View, AppearanceConsumer
where T: Identifiable & Filterable & ListRowProvider {
  
  class Model : ObservableObject {
    @Published var selected: T?
    
    init() {
      selected = nil
    }
  }
  
  var sheetSize: BottomSheet.SheetSize
  let title: String?
  let labelAction: (label: String,action: () -> ())?
  var selection: [T] = []
  @Binding var fieldValue: PickerFieldValue<T>
  let textToDisplay: (T) -> String
  @State private var state: InputControl.State = .normal
  @ObservedObject var model: Model = Model()
  
  internal init(sheetSize: BottomSheet.SheetSize, title: String? = nil, labelAction: (label: String,action: () -> ())? = nil, selection: [T], fieldValue: Binding<PickerFieldValue<T>>, textToDisplay: @escaping (T) -> String) {
    self.sheetSize = sheetSize
    self.selection = selection
    self.title = title
    self.labelAction = labelAction
    self.textToDisplay = textToDisplay
    self._fieldValue = fieldValue
    if fieldValue.wrappedValue.disabled {
      _state = .init(initialValue: .disabled)
    }
  }
  
  var body: some View {
    VStack {
      if !selection.isEmpty {
        ScrollView {
          VStack(spacing: 16) {
            ForEach(selection) { item in
              HStack{
                Text(textToDisplay(item))
                  .foregroundColor(itemColor)
                  .font(itemFont)
                Spacer()
                if let selected = model.selected,
                   selected.matches(lowercasedFilter: textToDisplay(item).lowercased()) {
                  createCheckmarkImage()
                    .foregroundColor(itemColor)
                }
              }.onTapGesture {
                select(item: item)
              }
            }
          }
        }
        .disabled(state == .disabled)
      }
    }.modifier(BottomSheet(sheetSize: sheetSize,
                           title: title,
                           labelAction: labelAction))
  }
  
  func createCheckmarkImage() -> Image {
    return Image(systemName: "checkmark")
  }
  
  func select(item: T) {
    model.selected = item
    fieldValue.value = item
  }

  var itemFont: Font {
    let spec = Self.appearance.dropdownListStyle.itemFontSpec
    ?? Self.appearance.fonts.body
    return .font(spec: spec, style: .body)
  }
  var itemColor: Color {
    Self.appearance.dropdownListStyle.itemFontColor?.color
    ?? Self.appearance.colors.textPrimaryShade4.color
  }
}


#if DEBUG

struct BottomSheet_Previews: PreviewProvider {
  static let countries = Array(Country.countries[0..<4])
  @State static var fieldValue = PickerFieldValue<Country>(field: Field(id: "id1",
                                                                        label: "Countries",
                                                                        required: false,
                                                                        placeholder: "One",
                                                                        info: "4 Countries"),
                                                           value: nil)
  
  static var previews: some View {
    BottomInfoSheet(sheetSize: .small, title: nil, info: "Some random info")
    BottomSelectionSheet(sheetSize: .medium,
                         selection: countries,
                         fieldValue: $fieldValue) { country in
      country.name
    }
  }
}

#endif
