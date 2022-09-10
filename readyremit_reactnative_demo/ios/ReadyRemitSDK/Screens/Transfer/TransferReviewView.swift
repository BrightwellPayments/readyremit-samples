//
//  TransferReviewView.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 4/25/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI


struct TransferReviewView: View, AppearanceConsumer {
  
  @ObservedObject var model: TransferReviewViewModel
  @State var invalidFields: [String] = []
  @State private var showConfirmationDetails = false
  @Binding var rootIsActive: Bool
  @Binding var transferIsActive: Bool
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        backgroundPageColor.color
        VStack(alignment: .leading) {
          ScrollView {
            VStack(spacing: 16) {
              if !invalidFields.isEmpty {
                ValidationErrorCardView(fieldLabelActions: invalidFields)
              }
              VStack(alignment: .leading, spacing: 12) {
                HorizontalButtonView(
                  title: L10n.rrmBankTransferScreenTitle,
                  buttonText: L10n.rrmEditButton,
                  function: { print("Edit") })
                HStack {
                  VStack (alignment: .leading) {
                    Text(L10n.rrmSendAmount)
                      .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                      .font(labelsFont)
                      .foregroundColor(titleTextColor)
                    
                    HStack {
                      FlagView(flagImage: FlagImage(currencyIso3Code: Constants.usdIso3Code), height: 15, width: 20)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 5))
                      Text(Constants.usdIso3Code)
                        .foregroundColor(countryIsoTextColor)
                        .font(flagsFont)
                    }
                    Text(model.quote.getSendAmount())
                      .padding(EdgeInsets(top: 6, leading: 16, bottom: 2, trailing: 16))
                      .font(quantitiesLabelFont)
                      .foregroundColor(titleTextColor)
                  }
                  Spacer()
                  VStack(alignment: .trailing) {
                    Text(L10n.rrmReceiveAmount)
                      .padding(EdgeInsets(top: 16, leading: 8, bottom: 0, trailing: 16))
                      .font(labelsFont)
                      .foregroundColor(titleTextColor)
                    
                    HStack {
                      Text(model.dstCountry.iso3Code)
                        .foregroundColor(countryIsoTextColor)
                        .font(flagsFont)
                      FlagView(flagImage: FlagImage(countryIso3Code: model.dstCountry.iso3Code), height: 15, width: 20)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 16))
                    }
                    Text(model.quote.getReceiveAmount(decimalPlaces: model.dstCurrency.decimalPlaces))
                      .padding(EdgeInsets(top: 6, leading: 16, bottom: 2, trailing: 16))
                      .font(quantitiesLabelFont)
                      .foregroundColor(titleTextColor)
                  }
                  
                }.frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .topLeading
                )
                
                ExchangeRateLabelView(srcCurrencyIsoCode: Constants.usdIso3Code,
                                      dstCurrencyIsoCode: model.dstCurrency.iso3Code,
                                      disabledRightLabel: false,
                                      transferRate: Binding.constant(model.quote.getRate()))
                Divider().padding(12)
                
                HorizontalTextView(leftLabel:L10n.rrmTransferFee,
                                   value: Binding.constant(model.quote.getTransferFee()),
                                   rightLabel: Constants.usdIso3Code,
                                   leftLabelForegroundColor: contentLabels,
                                   rightLabelForegroundColor: contentLabels)
                HorizontalTextView(leftLabel:L10n.rrmTotalCost,
                                   value: Binding.constant(model.quote.getTotalCost()),
                                   rightLabel: Constants.usdIso3Code,
                                   leftLabelForegroundColor: contentLabels,
                                   rightLabelForegroundColor: contentLabels)
                .padding(.bottom, 12)
              }
              .modifier(CardView())
              .padding(.top, 16)
              VStack(alignment: .leading, spacing: 16) {
                HorizontalButtonView(
                  title: L10n.rrmRecipientDetailsHeader,
                  buttonText: L10n.rrmEditButton,
                  function: { print("Edit") })
                HorizontalTextView(leftLabel: "*\(L10n.rrmRecipientType)",
                                   value: Binding.constant(""),
                                   rightLabel: model.newRecipient.recipientType,
                                   leftLabelForegroundColor: contentLabels,
                                   rightLabelForegroundColor: contentLabels)
                
                if let fields = model.newRecipient.fields {
                  ForEach(fields) { item in
                    let leftLabel = item.id.replacingOccurrences(of: "_", with: " ")
                    HorizontalTextView(leftLabel:"*\(leftLabel.capitalized)",
                                       value: Binding.constant(""),
                                       rightLabel: {switch item.value {
                                         case .phoneNumber:
                                         let phone = item.value.getValue as! PhoneNumber
                                         return "(+\(phone.countryPhoneCode)) \(phone.number)"
                                         case .string:
                                         return item.value.getValue as! String
                                         case .int:
                                         return item.value.getValue as! String
                                       }}(),
                                       leftLabelForegroundColor: contentLabels,
                                       rightLabelForegroundColor: contentLabels)
                  }
                }
              }
              .modifier(CardView())
              
              VStack(alignment: .leading, spacing: 16) {
                HorizontalButtonView(
                  title: L10n.rrmRecipientsBankDetailsHeader,
                  buttonText: L10n.rrmEditButton,
                  function: { print("Edit") })
                if let accountFields = model.newRecipientAccount.fields {
                  ForEach(accountFields) { item in
                    let leftLabel = item.id.replacingOccurrences(of: "_", with: " ")
                    HorizontalTextView(leftLabel:"*\(leftLabel.capitalized)",
                                       value: Binding.constant(""),
                                       rightLabel: item.value.getValue as! String,
                                       leftLabelForegroundColor: contentLabels,
                                       rightLabelForegroundColor: contentLabels)
                  }
                }
              }
              .modifier(CardView())
            }
          }
          .alertApiFailure($model.failure) {
            postCreateTransfer()
          }
          Spacer()
          if let quote = model.quote {
            Text(L10n.rrmSlaDisclaimerText(quote.deliverySLA.name) )
            .font(infoFont)
            .foregroundColor(infoColor.color)
            .padding(.bottom, 4)
            .padding(.horizontal, 16)
          }
          /*AttributedTextView(contents: model.getTermsOfUseAndPolicyContents(),
                             foregroundColor: infoColor,
                             backgroundColor: backgroundPageColor,
                             font: UIFont.convertFont(from: infoFont))*/
          Text(L10n.rrmPrivacyTermsofuseDisclaimer)
          .font(infoFont)
          .foregroundColor(infoColor.color)
          .padding(.horizontal, 16)
          .padding(.bottom, 16)
          
          let transfer = Bundle.sdk.decodeJson(Transfer.self, from: "Transfer")
          NavigationLink(destination: TransferConfirmationView(
            model: TransferConfirmationViewModel(apiSession: model.apiSession, transfer: transfer), rootIsActive: self.$rootIsActive, transferIsActive: self.$transferIsActive),
                         isActive: $showConfirmationDetails) {
            EmptyView()
          }.isDetailLink(false)
          
          Button(action: postCreateTransfer) {
            Text(L10n.rrmCompleteTransferButton)
          }
          .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
          .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity,
               minHeight: geometry.size.height,
               alignment: .top)
      }
    }
    .navigationBarTitle(Text(L10n.rrmReviewPageTitle),
                        displayMode: .inline)
  }
  
  func postCreateTransfer() {
    model.submitTransfer {
      showConfirmationDetails = true
    }
  }
  
  var infoFont: Font {
    let spec = Self.appearance.inputStyle.infoFontSpec ?? Self.appearance.fonts.footnote
    return .font(spec: spec, style: .footnote)
  }
  var infoColor: UIColor {
    Self.appearance.inputStyle.infoFontColor ??
    Self.appearance.colors.textPrimaryShade4
  }
  var titleTextColor: Color {
    Self.appearance.colors.textPrimaryShade3.color
  }
  var buttonTextColor: Color {
    Self.appearance.colors.textPrimaryShade4.color
  }
  var countryIsoTextColor: Color {
    Self.appearance.colors.textPrimaryShade1.color
  }
  var contentLabels: Color {
    Self.appearance.colors.textPrimaryShade1.color
  }
  var backgroundPageColor: UIColor {
    Self.appearance.colors.backgroundColorPrimary
  }
  var labelsFont: Font {
    let spec = Self.appearance.textfieldSubtitleFont
    return .font(spec: spec, style: .headline)
  }
  var flagsFont: Font {
    let spec = Self.appearance.textfieldSubtitleFont
    return .font(spec: spec, style: .subheadline)
  }
  var quantitiesLabelFont: Font {
    let spec = Self.appearance.textfieldSubtitleFont
    return .font(spec: spec, style: .title)
  }
}


#if DEBUG

struct TransferReviewView_Previews: PreviewProvider {
  static let token = OAuthToken(tokenType: "token",
                                accessToken: "access",
                                expiresInSeconds: 600)
  static let tokenStore = AuthTokenStore(authToken: token)
  static let session = ApiSession(environment: ApiEnvironment.mock, authTokenStore: tokenStore)
  static let model = TransferReviewViewModel(apiSession: session,
                                             quote: Quote.mock,
                                             dstCountry: Country.mock,
                                             recipient: CreateRecipient.getCreateRecipientMock(),
                                             bankDetails: RecipientAccount.getRecipientAccountMock(),
                                             dstCurrency: Currency.mockDestination)
  
  static var previews: some View {
    TransferReviewView(model: model, rootIsActive: Binding.constant(false), transferIsActive: Binding.constant(false))
  }
}

#endif
