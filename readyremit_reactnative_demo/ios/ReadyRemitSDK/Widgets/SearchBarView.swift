//
//  SearchBarView.swift
//  ReadyRemitSDK
//
import SwiftUI


struct SearchBarView: View, AppearanceConsumer {

  static let style = appearance.searchbarStyle

  @Binding var text: String
  @State private var searching = false

  var body: some View {
    HStack {
      HStack {
        if let image = Self.style.searchIcon {
          Image(uiImage: image)
        } else {
          Image(systemName: "magnifyingglass")
            .foregroundColor(searchIconColor)
        }
        TextField(L10n.rrmCommonSearchType, text: $text)
          .onTapGesture { initializeSearch() }
          .font(searchFont)
          .foregroundColor(searchFontColor)
        if !text.isEmpty {
          Button(action: resetText,
                 label: { Image(systemName: "multiply.circle.fill") })
            .foregroundColor(clearButtonColor)
            .transition(.move(edge: .trailing))
            .animation(.default)
        }
      }
      .padding(8)
      .background(backgroundColor)
      .cornerRadius(8)
      if searching {
        Button(action: cancelSearch,
               label: { Text(L10n.rrmCancelButton) })
          .modifier(BorderlessButtonModifier())
          .transition(.move(edge: .trailing))
          .animation(.default)
      }
    }
  }

  func initializeSearch() {
    withAnimation(.easeInOut) {
      searching = true
    }
  }

  func resetText() {
    withAnimation(.easeInOut) {
      text = ""
    }
  }

  func cancelSearch() {
    withAnimation(.easeInOut) {
      text = ""
      searching = false
      hideKeyboard()
    }
  }

  var searchIconColor: Color {
    Self.style.searchIconColor?.color ?? Self.appearance.colors.controlShade2.color
  }
  var searchFont: Font {
    let spec = Self.style.searchFontSpec ?? Self.appearance.fonts.subheadline
    return .font(spec: spec, style: .subheadline)
  }
  var searchFontColor: Color {
    Self.style.searchFontColor?.color ?? Self.appearance.colors.textPrimaryShade1.color
  }
  var clearButtonColor: Color {
    Self.style.clearButtonColor?.color ?? Self.appearance.colors.controlAccessoryShade1.color
  }
  var cancelButtonFont: Font {
    .font(spec: Self.style.cancelButtonFontSpec, style: .body)
  }
  var cancelButtonColor: Color {
    Self.style.cancelButtonFontColor?.color ?? Self.appearance.colors.primaryShade1.color
  }
  var backgroundColor: Color {
    Self.style.backgroundColor?.color ?? Self.appearance.colors.backgroundColorTertiary.color
  }
}


#if DEBUG

struct SearchBarView_Previews: PreviewProvider {

  @State static var text: String = ""

  static var previews: some View {
    VStack(spacing: 20) {
      SearchBarView(text: .constant(""))
      SearchBarView(text: .constant("searching"))
    }
      .padding()
      .previewLayout(.sizeThatFits)
  }
}

#endif
