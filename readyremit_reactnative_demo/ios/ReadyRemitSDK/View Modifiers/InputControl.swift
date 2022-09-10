//
//  InputControl.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct InputControl: ViewModifier, AppearanceConsumer {

  @Environment(\.colorScheme) var colorScheme
  let label: String
  let required: Bool
  let hideLabel: Bool
  let isLineField: Bool
  let info: String
  var isLoading: Binding<Bool>?
  @Binding var state: InputControl.State
  @Binding var validationState: ValidationResult

  @SwiftUI.State private var showSheet = false
  @SwiftUI.State var isTruncated: Bool = false
  @SwiftUI.State var validationHeight: CGFloat = 100
  
  func body(content: Content) -> some View {
    VStack(alignment: .leading, spacing: 6) {
      createLabel()
        .font(labelFont)
        .foregroundColor(labelForegroundColor)
      content
        .modifier(LineInputControlChrome(isLineField: isLineField,
                                         state: $state,
                                         validationState: $validationState))
      if validationState != .none {
        createValidationText()
          .font(validationFont)
          .foregroundColor(labelForegroundColor)
      }
      if !info.isEmpty {
        createInfoText()
          .foregroundColor(infoForegroundColor)
      }
    }
    .onPreferenceChange(HeightPreferenceKey.self, perform: { validationHeight = $0 })
    .sheet(isPresented: $showSheet,
           content: {
      ExpandedInfoSheet(info: info)
    })
  }

  @ViewBuilder func createLabel() -> some View {
    HStack {
    switch (hideLabel, required) {
    case (true, _):
      Text(" ")
    case (_, false):
      Text(label)
    case (_, true):
        Text("*").foregroundColor(requiredIndicatorColor)
        Text("\(label)")
    }
      if let loading = isLoading, loading.wrappedValue {
        ActivityIndicator(animated: true, foregroundColor: activityIndicatorColor)
          .frame(width: 18, height: 18, alignment: .center)
      }
    }
  }

  @ViewBuilder func createValidationText() -> some View {
    switch validationState {
    case .none:
      Text(" ")
    case .success:
      HStack {
        createValidationImageSuccess()
          .infoIconModifier(height: validationHeight)
        Text(L10n.rrmCommonValidationSuccess)
          .background(GeometryReader { reader in
            Color.clear.preference(key: HeightPreferenceKey.self, value: reader.size.height)
          })
      }
    case .fail(let messages):
      HStack(alignment: .top) {
        createValidationImageError()
          .infoIconModifier(height: validationHeight)
        VStack(alignment: .leading) {
          ForEach(messages, id: \.self) {
            Text($0)
              .background(GeometryReader { reader in
                Color.clear.preference(key: HeightPreferenceKey.self, value: reader.size.height)
              })
          }
        }
      }
    }
  }
  
  @ViewBuilder func createInfoText() -> some View {
    HStack(alignment: .top, spacing: 5) {
      TruncatableText(
        text: Text(info),
        lineLimit: 1
      ) {
        isTruncated = $0
      }
      .font(infoFont)
      if isTruncated {
        Button(L10n.rrmCommonReadMore) {
          showSheet.toggle()
        }
        .font(infoFont)
        .foregroundColor(buttonForegroundColor)
      }
    }
  }

  func createValidationImageError() -> Image {
    if let uiImage = Self.appearance.inputStyle.validationErrorIcon {
      return Image(uiImage: uiImage)
    }
    return Image(systemName: "exclamationmark.circle.fill")
  }

  func createValidationImageSuccess() -> Image {
    if let uiImage = Self.appearance.inputStyle.validationSuccessIcon {
      return Image(uiImage: uiImage)
    }
    return Image(systemName: "checkmark.circle.fill")
  }
  
  var activityIndicatorColor: UIColor {
    (colorScheme == .light) ? .black : .white
  }

  var labelFont: Font {
    let spec = Self.appearance.inputStyle.labelFontSpec ?? Self.appearance.fonts.footnoteEmphasis
    return .font(spec: spec, style: .footnote)
  }
  
  var labelForegroundColor: Color {
    validationState == .none ? labelTextColor : validationState.labelTextColor
  }
  
  var labelTextColor: Color {
    switch self.state {
    case .normal:
      return Self.appearance.inputStyle.labelFontColor?.color
      ?? ((colorScheme == .light) ? Self.appearance.colors.textPrimaryShade3.color : Self.appearance.colors.textPrimaryShade4.color)
    case .active:
      return Self.appearance.inputStyle.labelFontColorActive?.color
      ?? Self.appearance.colors.primaryShade1.color
    case .disabled:
      return Self.appearance.inputStyle.labelFontColorDisabled?.color
      ?? Self.appearance.colors.textTertiaryDisabled.color
    }
  }
  
  var requiredIndicatorColor: Color {
    validationState == .none ? (Self.appearance.inputStyle.requiredIndicatorColor?.color ?? Self.appearance.colors.error.color) : validationState.labelTextColor
  }

  var validationFont: Font {
    let spec = Self.appearance.inputStyle.validationFontSpec ?? Self.appearance.fonts.caption
    return .font(spec: spec, style: .caption)
  }

  var infoFont: Font {
    let spec = Self.appearance.inputStyle.infoFontSpec ?? Self.appearance.fonts.caption
    return .font(spec: spec, style: .caption)
  }
  
  var infoForegroundColor: Color {
    Self.appearance.inputStyle.infoFontColor?.color ??
    ((colorScheme == .light) ?
     Self.appearance.colors.textPrimaryShade3.color : Self.appearance.colors.textPrimaryShade4.color)
  }
  
  var buttonForegroundColor: Color {
    Self.appearance.inputStyle.hyperlinkColor?.color ??
    ((colorScheme == .light) ? Self.appearance.colors.inputUnderLineActive.light.color
     : Self.appearance.colors.inputUnderLineActive.dark.color)
  }
}

fileprivate extension Image {
  func infoIconModifier(height: CGFloat) -> some View {
    self
      .resizable()
      .frame(width: height, height: height)
      .scaledToFit()
  }
}

extension InputControl {

  enum State {
    case normal, active, disabled
  }
}


extension InputControl.State : AppearanceConsumer {

  var mainTextColor: Color {
    switch self {
    case .normal, .active:
      return Self.appearance.inputStyle.inputFontColor?.color
      ?? Self.appearance.colors.textPrimaryShade4.color
    case .disabled:
      return Self.appearance.inputStyle.inputFontColorDisabled?.color
      ?? Self.appearance.colors.textPrimaryDisabled.color
    }
  }
  
  func placeholderTextColor(colorScheme: ColorScheme) ->Color {
    switch self {
    case .normal, .active:
      return Self.appearance.inputStyle.placeholderFontColor?.color
      ?? ((colorScheme == .light) ? Self.appearance.colors.textPrimaryShade2.color : Self.appearance.colors.textPrimaryShade1.color)
    case .disabled:
      return Self.appearance.inputStyle.placeholderFontColorDisabled?.color
      ?? Self.appearance.colors.textTertiaryDisabled.color
    }
  }
  
  var buttonDropdownColor: Color {
    switch self {
    case .normal, .active:
      return Self.appearance.inputStyle.buttonDropdownColor?.color
      ?? Self.appearance.colors.controlAccessoryShade1.color
    case .disabled:
      return Self.appearance.inputStyle.buttonDropdownColorDisabled?.color
      ?? Self.appearance.colors.controlAccessoryShade2.color
    }
  }

  var borderColor: Color {
    switch self {
    case .normal:
      return Self.appearance.inputStyle.borderColorNormal?.color
      ?? Self.appearance.colors.controlShade2.color
    case .active:
      return Self.appearance.inputStyle.borderColorActive?.color
      ?? Self.appearance.colors.primaryShade1.color
    case .disabled:
      return Self.appearance.inputStyle.borderColorDisabled?.color
      ?? Self.appearance.colors.controlShade1.color
    }
  }

  var infoTextColor: Color {
    switch self {
    case .normal:
      return Self.appearance.inputStyle.infoFontColor?.color
      ?? Self.appearance.colors.textPrimaryShade1.color
    case .active:
      return Self.appearance.inputStyle.infoFontColorActive?.color
      ?? Self.appearance.colors.primaryShade1.color
    case .disabled:
      return Self.appearance.inputStyle.infoFontColorDisabled?.color
      ?? Self.appearance.colors.textQuaternaryDisabled.color
    }
  }
}


#if DEBUG

struct InputControl_Previews : PreviewProvider {
//  static func setup() {
//    ReadyRemit.shared.appearance.colors.configureCustom()
//  }
  static let states: [InputControl.State] = {
//    setup()
    return [.normal, .active]
  }()
  static let valids = [ValidationResult.none, .success, .fail(["failed"])]

  static var previews: some View {
    List {
      ForEach(states, id:\.self) { state in
        ForEach(valids, id: \.self) { valid in
          Text("state \(String(describing: state)) - valid \(String(describing: valid))")
            .modifier(InputControl(label: "Label",
                                   required: true,
                                   hideLabel: false,
                                   isLineField: true,
                                   info: "Assertive Text",
                                   isLoading: Binding.constant(valid == .none),
                                   state: .constant(state),
                                   validationState: .constant(valid)))
        }
      }
    }.previewLayout(.sizeThatFits)
  }
}
#endif
