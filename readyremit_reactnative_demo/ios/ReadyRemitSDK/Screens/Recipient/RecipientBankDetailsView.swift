//
//  RecipientBankDetailsView.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 4/25/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI


struct RecipientBankDetailsView: View, AppearanceConsumer {
  
  @ObservedObject var model: RecipientBankDetailsViewModel
  @State var invalidFields: [String] = []
  @State private var startReviewDetails = false
  @Binding var rootIsActive: Bool
  @Binding var transferIsActive: Bool
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        backgroundPageColor
        VStack {
            ScrollView {
              VStack(spacing: 16) {
                let _ = !invalidFields.isEmpty
                VStack(alignment: .leading, spacing: 10) {
                  if model.recipientFieldsAccountResponse?.fieldSets != nil {
                    ForEach(0..<model.accountFields.count, id: \.self) { i in
                      let order: Int = model.accountFields[i].fieldReadonlyData.order!
                      let title = model.accountFields[i].fieldReadonlyData.group!
                      if order == 0 {
                        Text(title)
                          .font(infoTitleFont)
                          .foregroundColor(infoTitleColor)
                          .padding(.horizontal, 16)
                      }
                      
                      switch model.accountFields[i] {
                      case _ as StringValue:
                        FieldInputText(fieldValue: Binding(get: { model.accountFields[i] as! StringValue },
                                                           set: { model.accountFields[i] = $0 }))
                      case _ as FieldValue<CountryCallingCodeValue>:
                        let selection = Bundle.sdk.decodeJson([CountryCallingCode].self, from: "CountryCallingCodes")
                        let callingCode = selection.filter{ $0.iso3Code == model.dstCountry.iso3Code }
                        PhoneNumberField(selection: [CountryCallingCode(name: model.dstCountry.name, iso3Code: model.dstCountry.iso3Code, callingCode: callingCode[0].callingCode)],
                                         selectedFieldValue: Binding(get: { model.accountFields[i] as! FieldValue<CountryCallingCodeValue> },
                                                                     set: { model.accountFields[i] = $0 }))
                      case _ as FieldValue<DateValue>:
                        DateField(fieldValue: Binding(get: { model.accountFields[i] as! FieldValue<DateValue> },
                                                      set: { model.accountFields[i] = $0 })).padding(.bottom, 15)
                      case _ as PickerFieldValue<OptionsSet>:
                        DynamicPickerField(maf: Binding.constant(model.accountFields[i] as! PickerFieldValue<OptionsSet>), options: self.$model.banksResponse, isLoading: Binding.constant(model.isLoading))
                      default:
                        Text("").hidden()
                      }
                    }
                  }
                }
                .modifier(CardView())
              }
            }
          Spacer()
          Text(L10n.rrmRecipientAccountDetailsreviewdisclaimer)
            .font(infoFont)
            .foregroundColor(infoColor)
            .padding(16)
          if let vm = model.transferReviewVM {
            NavigationLink(destination: TransferReviewView(model: vm, rootIsActive: self.$rootIsActive, transferIsActive: self.$transferIsActive),
                           isActive: $startReviewDetails) {
              EmptyView()
            }.isDetailLink(false)
          }
          Button(action: validate) {
            Text(L10n.rrmNextReviewButton)
          }
          .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
          .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity,
               minHeight: geometry.size.height,
               alignment: .top)
        .onAppear {
          model.fetchRecipientAccountFields(dstCountry: model.dstCountry.iso3Code, dstCurrency: model.dstCurrency.iso3Code)
          model.getBanksList(url: model.apiUrl ?? "")
        }
      }
      .alertApiFailure($model.failure) {
        model.failure = nil
      }
    }
    .navigationBarTitle(Text(L10n.rrmRecipientBankDetailsScreenTitle),
                        displayMode: .inline)
  }
  
  func validate() {
    let recipientAccountsApi = UserDefaults.standard.bool(forKey: "recipientAccountsApi")
    if recipientAccountsApi {
      invalidFields = model.validate()
      if invalidFields.isEmpty {
        model.postRecipientAccount {
          startReviewDetails = true
        }
        UserDefaults.standard.set(false, forKey: "recipientAccountsApi")
      }
    }else {
      invalidFields = model.validate()
      if invalidFields.isEmpty {
        startReviewDetails = true
      }else {
        UserDefaults.standard.set(true, forKey: "recipientAccountsApi")
      }
    }
  }
  
  var infoFont: Font {
    let spec = Self.appearance.inputStyle.infoFontSpec ?? Self.appearance.fonts.footnote
    return .font(spec: spec, style: .footnote)
  }
  var infoTitleFont: Font {
    let spec = Self.appearance.inputStyle.inputFontSpec
    ?? Self.appearance.fonts.callout
    return .font(spec: spec, style: .callout)
  }
  var infoTitleColor: Color {
    Self.appearance.inputStyle.infoFontColor?.color
    ?? Self.appearance.colors.textPrimaryShade4.color
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

struct RecipientBankDetailsView_Previews: PreviewProvider {
  static let token = OAuthToken(tokenType: "token",
                                           accessToken: "access",
                                           expiresInSeconds: 600)
  static let tokenStore = AuthTokenStore(authToken: token)
  static let session = ApiSession(environment: ApiEnvironment.mock, authTokenStore: tokenStore)
  static let model = RecipientBankDetailsViewModel(apiSession: session,
                                               quote: Quote.mock,
                                                   dstCountry: Country.mock,
                                                   recipient: CreateRecipient.getCreateRecipientMock(),
                                                   dstCurrency: Currency.mockDestination)
  
  static var previews: some View {
    RecipientBankDetailsView(model: model, rootIsActive: Binding.constant(false), transferIsActive: Binding.constant(false))
  }
}

#endif
