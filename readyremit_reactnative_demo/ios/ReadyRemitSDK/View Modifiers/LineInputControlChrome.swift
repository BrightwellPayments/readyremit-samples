//
//  LineInputControlChrome.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct LineInputControlChrome: ViewModifier, AppearanceConsumer {

  static let style = appearance.inputStyle

  let isLineField: Bool
  @Binding var state: InputControl.State
  @Binding var validationState: ValidationResult

  func body(content: Content) -> some View {
    VStack(spacing: 6) {
      content
      if isLineField {
        Rectangle()
          .fill(borderColor)
          .frame(height: borderWidth)
      }
    }
  }

  var borderColor: Color {
    switch state {
    case .normal: return validationState.borderColor
    case .active, .disabled: return state.borderColor
    }
  }

  var borderWidth: CGFloat {
    switch state {
    case .active: return Self.style.borderWidthActivated ?? 2
    case .normal, .disabled: return Self.style.borderWidth ?? 1
    }
  }
}



#if DEBUG

struct InputControlChrome_Previews : PreviewProvider {
  static func setup() {
    ReadyRemit.shared.appearance.colors.configureCustom()
  }

  static let states: [InputControl.State] = {
    setup()
    return [InputControl.State.normal, .active]
  }()
  static let valids = [ValidationResult.none, .success, .fail(["fail"])]

  static var previews: some View {
    VStack(spacing: 8) {
      ForEach(states, id:\.self) { state in
        ForEach(valids, id:\.self) { valid in
          Text("state \(String(describing: state)) - valid \(String(describing: valid))")
            .modifier(LineInputControlChrome(isLineField: true,
                                             state: .constant(state),
                                             validationState: .constant(valid)))
        }
      }
    }.previewLayout(.sizeThatFits)
  }
}
#endif
