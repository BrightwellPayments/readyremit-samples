//
//  DropdownList.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Combine
import SwiftUI


protocol Filterable {
  func matches(lowercasedFilter: String) -> Bool
}


protocol ListRowProvider {
  associatedtype Content: View
  @ViewBuilder func row() -> Content
}


struct DropdownList<T> : View, AppearanceConsumer
where T: Identifiable & Filterable & ListRowProvider {

  class Model<T>: ObservableObject where T: Identifiable & Filterable {

    let title: String?
    let data: [T]
    @Binding var selected: T?

    init(title: String?, data: [T], selected: Binding<T?>) {
      self.title = title
      self.data = data
      self._selected = selected
      self.filtered = data
      filterPublisher = $filter
        .receive(on: RunLoop.main)
        .sink(receiveValue: { newFilter in
          if newFilter.isEmpty {
            self.filtered = data
          } else {
            let lowerFilter = newFilter.lowercased()
            self.filtered = data.filter({
              $0.matches(lowercasedFilter: lowerFilter)
            })
          }
        })
    }

    @Published var filter: String = ""
    @Published var filtered: [T]
    private var filterPublisher = AnyCancellable({})
  }


  @ObservedObject var model: Model<T>
  @Environment(\.presentationMode) var presentation

  var body: some View {
    VStack {
      Spacer()
      VStack(spacing: 20) {
        HStack {
          if let title = model.title, !title.isEmpty {
            Text(title)
              .foregroundColor(titleColor)
          }
          Spacer()
          Button(action: dismiss, label: backButton)
        }
        .font(titleFont)
        if model.data.count > 10 {
          SearchBarView(text: $model.filter)
        }
        ScrollView {
          ForEach(model.filtered) { toSelect in
            toSelect.row()
              .font(itemFont)
              .foregroundColor(itemColor)
              .background(Color.tappable)
              .onTapGesture { dismiss(andSelect: toSelect) }
          }
          Text(" ")
        }
        Spacer()
      }
      .padding()
      .background(backgroundColor)
      .cornerRadius(8)
      .modifier(Height(height: listHeight))
      .onTapGesture { hideKeyboard() }
    }
    .background(DynamicSizeSheetBackgroundView().onTapGesture(perform: dismiss))
    .edgesIgnoringSafeArea(.all)
  }

  func dismiss() {
    presentation.wrappedValue.dismiss()
  }

  func dismiss(andSelect select: T) {
    model.selected = select
    dismiss()
  }

  @ViewBuilder func backButton() -> some View {
    Text("Cancel").foregroundColor(backButtonColor)
  }

  var listHeight: CGFloat? {
    switch model.data.count {
    case ...4: return UIScreen.main.bounds.height / 3
    case ...12: return UIScreen.main.bounds.height * 2 / 3
    default: return nil
    }
  }

  var backButtonColor: Color {
    Self.appearance.dropdownListStyle.backButtonColor?.color
    ?? Self.appearance.colors.primaryShade1.color
  }
  var titleFont: Font {
    let spec = Self.appearance.fonts.title3
    return .font(spec: spec, style: .headline)
  }
  var titleColor: Color {
    Self.appearance.dropdownListStyle.titleFontColor?.color
    ?? Self.appearance.colors.textPrimaryShade4.color
  }
  var itemFont: Font {
    let spec = Self.appearance.fonts.body
    return .font(spec: spec, style: .body)
  }
  var itemColor: Color {
    Self.appearance.dropdownListStyle.itemFontColor?.color
    ?? Self.appearance.colors.textPrimaryShade4.color
  }
  var backgroundColor: Color {
    Self.appearance.colors.backgroundColorPrimary.color
  }
}
