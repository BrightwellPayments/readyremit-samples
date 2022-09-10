//
//  NetworkAPIErrorBanner.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 3/30/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI


struct NetworkAPIErrorBanner: ViewModifier, AppearanceConsumer {
  
  @Environment(\.colorScheme) var colorScheme
  var failure: Binding<ApiFailure?>
  let action: () -> ()
  @State private var showErrorBanner = false
  
  func body(content: Content) -> some View  {
    if let failure = failure.wrappedValue {
      switch failure {
      case .network(_):
        content
          .disabled(false)
          .overlay(createBannerOverlay(failure: failure)
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .topLeading)
            .allowsHitTesting(true),
            alignment: .topLeading)
      case .unexpected(_):
        content
          .disabled(false)
          .overlay(createBannerOverlay(failure: failure)
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .topLeading)
            .allowsHitTesting(true),
            alignment: .topLeading)
      case .tokenExpired(let errors):
        content
          .disabled(false)
          .overlay(createBannerOverlay(errors: errors)
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .topLeading)
            .allowsHitTesting(true),
            alignment: .topLeading)
      case .tokenInvalid(let errors):
        content
          .disabled(false)
          .overlay(createBannerOverlay(errors: errors)
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .topLeading)
            .allowsHitTesting(true),
            alignment: .topLeading)
      case .failure(let errors):
        content
          .disabled(false)
          .overlay(createBannerOverlay(errors: errors)
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .topLeading)
            .allowsHitTesting(true),
            alignment: .topLeading)
      }
    } else {
      content
    }
  }
  
  func createBannerOverlay(failure: ApiFailure) -> some View {
    return createBannerOverlayView(errors: [failure.message])
  }
  
  func createBannerOverlay(errors: [ApiError]) -> some View {
    var apiErrors: [String] = []
    for apiError in errors {
      apiErrors.append(apiError.message)
    }
    return createBannerOverlayView(errors: apiErrors)
  }
  
  func createBannerOverlayView(errors: [String]) -> some View {
    VStack {
      if showErrorBanner {
        HStack(alignment: .top) {
          createErrorImage()
            .foregroundColor(iconColor)
          
          VStack(alignment: .leading, spacing: 4) {
            ForEach(errors, id: \.self) { error in
              Text(error)
                .font(messageFont)
                .foregroundColor(messageColor)
            }
            
            Button(L10n.rrmErrorTryAgain) {
              self.animate() { self.showErrorBanner = false }
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                action()
              }
            }
            .font(hyperlinkFont.bold())
            .foregroundColor(hyperlinkColor)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .top),
                                removal: AnyTransition.move(edge: .top)))
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        .background(backgroundColor)
      }
      Spacer()
    }
    .contentShape(Rectangle())
    .onAppear {
      self.animate() { self.showErrorBanner = true }
    }
  }
  
  func createErrorImage() -> Image {
    if let uiImage = Self.appearance.inputStyle.validationErrorIcon {
      return Image(uiImage: uiImage)
    }
    return Image(systemName: "exclamationmark.circle.fill")
  }
  
  func animate(action: @escaping () -> Void) {
    DispatchQueue.main.async() {
      withAnimation {
        action()
      }
    }
  }
  
  var backgroundColor: Color {
    Self.appearance.inputStyle.borderColorError?.color ??
    ((colorScheme == .light) ? Self.appearance.colors.errorBackground.light.color : Self.appearance.colors.errorBackground.dark.color)
  }
  var iconColor: Color {
    Self.appearance.inputStyle.borderColorError?.color ?? Self.appearance.colors.error.color
  }
  var hyperlinkColor: Color {
    Self.appearance.inputStyle.hyperlinkColor?.color ??
    ((colorScheme == .light) ? Self.appearance.colors.inputUnderLineActive.light.color
     : Self.appearance.colors.inputUnderLineActive.dark.color)
  }
  var hyperlinkFont: Font {
    let spec = Self.appearance.inputStyle.infoFontSpec ?? Self.appearance.fonts.footnote
    return .font(spec: spec, style: .footnote)
  }
  var messageColor: Color { Self.appearance.inputStyle.inputFontColor?.color ?? Self.appearance.colors.textPrimaryShade4.color }
  var messageFont: Font {
    let spec = Self.appearance.inputStyle.infoFontSpec ?? Self.appearance.fonts.footnote
    return .font(spec: spec, style: .footnote)
  }
}


extension View {
  
  func alertApiFailure(_ failure: Binding<ApiFailure?>, action: @escaping () -> ()) -> some View {
    self.modifier(NetworkAPIErrorBanner(failure: failure, action: action))
  }
}
