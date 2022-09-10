//
//  RecipientIdentityVerifier.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 25/08/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//

import Combine
import SwiftUI

struct RecipientIdentityVerifier: View, AppearanceConsumer {
  @Environment(\.presentationMode) var presentationMode
  @State var countries: [Country]
  @State var openIdology: Bool = false
  @State var refresh: Bool = false
  @State var isLoading: Bool = false
  @State var countryCode: String = ""
  @State var apiSession: ApiSession
  
  @State var fieldValue = PickerFieldValue<Country>(
    field: Field(id: UUID().uuidString,
                 label: L10n.rrmCountryId,
                 required: true,
                 placeholder: L10n.rrmCountryId,
                 info: ""),
    value: nil)
  
    var body: some View {
      GeometryReader { geometry in
        ScrollView {
          VStack {
            Text(L10n.rrmVerifyTopText)
            .font(infoFont)
            .foregroundColor(infoColor.color)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            if !countries.isEmpty {
              LinePickerField(selection: countries,
                              fieldValue: Binding.constant(fieldValue),
                              textToDisplay: { country in
                country.name
                }).padding(.vertical, 10)
            }
            
            Text(L10n.rrmVerifyBottomText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(infoFont)
            .foregroundColor(infoColor.color)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            let icvm = IdentityConfirmationViewModel(apiSession: apiSession)
            NavigationLink(destination: RecipientIdentityConfirmation(docSide: DocSide.none, dstCountryCode: countryCode, model: icvm), isActive: $openIdology) { EmptyView() }
            
            Text(L10n.rrmVerifyDisclaimer)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(infoFont)
            .foregroundColor(infoColor.color)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            Button(action: validate) { Text(L10n.rrmVerifyDocumentButton) }
              .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
              .padding(.vertical, 10)
            
          }
          .modifier(CardView())
          .padding(.top, 15)
        }
          .frame(maxWidth: .infinity,
                 minHeight: geometry.size.height,
                 alignment: .top)
          .overlay(isLoading ? LoadingStateView() : nil)
      }
      .navigationBarTitle(Text(L10n.rrmVerifyTitle), displayMode: .inline)
      .onAppear(perform: {
        let kyc = UserDefaults.standard.string(forKey: "kycStatus")
        let imagesAreDone = UserDefaults.standard.bool(forKey: "imagesAreDone")
        if kyc == nil && imagesAreDone {
          UserDefaults.standard.removeObject(forKey: "imagesAreDone")
          presentationMode.wrappedValue.dismiss()
        }
      })
      .background(backgroundPageColor)
      
    }
  
  private func validate() {
    isLoading = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      let countrySelected = fieldValue.value?.iso3Code
      guard countrySelected != nil else {
        self.fieldValue.validation = .fail([L10n.rrmNoCountrySelected])
        isLoading = false
        return
      }
      countryCode = countrySelected!
      isLoading = false
      self.openIdology = true
    }
  }
  
  var backgroundPageColor: Color {
    Self.appearance.colors.backgroundColorPrimary.color
  }
  var infoFont: Font {
    let spec = Self.appearance.inputStyle.infoFontSpec ?? Self.appearance.fonts.footnote
    return .font(spec: spec, style: .footnote)
  }
  var infoColor: UIColor {
    Self.appearance.inputStyle.infoFontColor ??
    Self.appearance.colors.textPrimaryShade4
  }
}

#if DEBUG
struct RecipientIdentityVerifier_Previews: PreviewProvider {
  static let countriesList = [Country]()
  static let token = OAuthToken(tokenType: "token",
                                           accessToken: "access",
                                           expiresInSeconds: 600)
  static let tokenStore = AuthTokenStore(authToken: token)
  static let session = ApiSession(environment: ApiEnvironment.mock,
                                  authTokenStore: tokenStore)
    static var previews: some View {
      RecipientIdentityVerifier(countries: countriesList, apiSession: session)
    }
}
#endif
