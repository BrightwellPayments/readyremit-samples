//
//  RecipientDetailsView.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 4/25/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation
import SwiftUI
import Combine


struct RecipientDetailsView: View, AppearanceConsumer {
  
  @ObservedObject var model: RecipientDetailsViewModel
  @State var invalidFields: [String] = []
  @State private var startRecipientBankDetails = false
  @Binding var rootIsActive: Bool
  @Binding var transferIsActive: Bool
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        backgroundPageColor
        ScrollView {
          VStack {
              VStack(spacing: 10) {
                let _ = !invalidFields.isEmpty
                VStack(alignment: .leading, spacing: 5) {
                  Text(L10n.rrmFraudWarningTitle)
                    .font(infoTitleFont)
                    .foregroundColor(infoTitleColor)
                    .bold()
                    .padding(.top, 11)
                    .padding(.horizontal, 16)
                  Text(L10n.rrmFraudWarningContent)
                    .font(infoFont)
                    .foregroundColor(infoColor)
                    .padding(.bottom, 11)
                    .padding(.horizontal, 16)
                }
                .modifier(CardView())
                VStack(alignment: .leading, spacing: 10) {
                  if model.recipientFieldsResponse?.fieldSets != nil {
                    ScrollView {
                      VStack(alignment: .leading, spacing: 10) {
                        ForEach(0..<model.allFields.count, id: \.self) { i in
                          let order: Int = model.allFields[i].fieldReadonlyData.order!
                          let title = model.allFields[i].fieldReadonlyData.group!
                          if order == 0 {
                            Text(title)
                              .font(infoTitleFont)
                              .foregroundColor(infoTitleColor)
                              .padding(.horizontal, 16)
                          }

                          switch model.allFields[i] {
                          case _ as StringValue:
                            FieldInputText(fieldValue: Binding(get: { model.allFields[i] as! StringValue },
                                                               set: { model.allFields[i] = $0 }))
                          case _ as FieldValue<CountryCallingCodeValue>:
                            let selection = Bundle.sdk.decodeJson([CountryCallingCode].self, from: "CountryCallingCodes")
                            let callingCode = selection.filter{ $0.iso3Code == model.dstCountry.iso3Code }
                            PhoneNumberField(selection: [CountryCallingCode(name: model.dstCountry.name, iso3Code: model.dstCountry.iso3Code, callingCode: callingCode[0].callingCode)],
                                             selectedFieldValue: Binding(get: { model.allFields[i] as! FieldValue<CountryCallingCodeValue> },
                                                                         set: { model.allFields[i] = $0 }))
                          case _ as FieldValue<DateValue>:
                            DateField(fieldValue: Binding(get: { model.allFields[i] as! FieldValue<DateValue> },
                                                          set: { model.allFields[i] = $0 })).padding(.bottom, 15)
                          case _ as PickerFieldValue<OptionsSet>:
                            DynamicPickerField(maf: Binding.constant(model.allFields[i] as! PickerFieldValue<OptionsSet>), options: Binding.constant(model.allFields[i].fieldReadonlyData.options), isLoading: Binding.constant(model.isLoading))
                          default:
                            Text("").hidden()
                          }
                        }
                      }
                    }
                  }
                }
                .modifier(CardView())
                .onAppear{
                  model.fetchRecipientFields(dstCountry: "\(model.dstCountry.iso3Code)", dstCurrency: "\(model.dstCurrency.iso3Code)")
                }

              }
            Spacer()
            Text(L10n.rrmRecipientDetailsReviewDisclaimer)
              .font(infoFont)
              .foregroundColor(infoColor)
              .padding(.bottom, 16)
              .padding(.horizontal, 16)
            if let vm = model.recipientBankDetailsViewModel {
              NavigationLink(destination: RecipientBankDetailsView(model: vm, rootIsActive: self.$rootIsActive, transferIsActive: self.$transferIsActive),
                             isActive: $startRecipientBankDetails) {
                EmptyView()
              }.isDetailLink(false)
            }
            Button(action: validate) {
              Text(L10n.rrmNextRecipientBankdetailsButton)
            }
            .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
            .padding(.bottom, 10)
          }
        }
        .frame(maxWidth: .infinity,
               minHeight: geometry.size.height,
               alignment: .top)
      }
      .alertApiFailure($model.failure) {
        if model.isSendDataFailure! {
          model.createRecipient {
            navigateToNextScreen()
          }
          model.failure = nil
        }else{
          model.fetchRecipientFields(dstCountry: "\(model.dstCountry.iso3Code)", dstCurrency: "\(model.dstCurrency.iso3Code)")
          model.failure = nil
        }
      }
    }
    .navigationBarTitle(Text(L10n.rrmRecipientDetailsHeader),
                        displayMode: .inline)
  }
  
  func validate() {
    let recipientDetailsApi = UserDefaults.standard.bool(forKey: "recipientDetailsApi")
    if recipientDetailsApi {
      invalidFields = model.validate()
      if invalidFields.isEmpty {
        model.createRecipient {
          navigateToNextScreen()
        }
        UserDefaults.standard.set(false, forKey: "recipientDetailsApi")
      }
    }else {
      invalidFields = model.validate()
      if invalidFields.isEmpty {
        navigateToNextScreen()
      }else {
        UserDefaults.standard.set(true, forKey: "recipientDetailsApi")
      }
    }
  }
  
  func navigateToNextScreen() {
    startRecipientBankDetails = true
  }
  
  var infoTitleFont: Font {
    let spec = Self.appearance.fonts.callout
    return .font(spec: spec, style: .callout)
  }
  var infoTitleColor: Color {
    Self.appearance.inputStyle.infoFontColor?.color
    ?? Self.appearance.colors.textPrimaryShade4.color
  }
  var infoFont: Font {
    let spec = Self.appearance.fonts.footnote
    return .font(spec: spec, style: .footnote)
  }
  var infoColor: Color {
    Self.appearance.inputStyle.infoFontColor?.color ??
    Self.appearance.colors.textPrimaryShade4.color
  }
  var backgroundPageColor: Color {
    Self.appearance.colors.backgroundColorPrimary.color
  }
}


#if DEBUG

struct RecipientDetailsView_Previews: PreviewProvider {
  
  static let token = OAuthToken(tokenType: "token",
                                           accessToken: "access",
                                           expiresInSeconds: 600)
  static let tokenStore = AuthTokenStore(authToken: token)
  static let session = ApiSession(environment: ApiEnvironment.mock, authTokenStore: tokenStore)
  static let model = RecipientDetailsViewModel(apiSession: session,
                                               quote: Quote.mock,
                                               dstCountry: Country.mock,
                                               dstCurrency: Currency.mockDestination)
  
  static var previews: some View {
    Group {
      RecipientDetailsView(model: model, rootIsActive: Binding.constant(false), transferIsActive: Binding.constant(false))
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
      RecipientDetailsView(model: model, rootIsActive: Binding.constant(false), transferIsActive: Binding.constant(false))
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
  }
}

#endif
