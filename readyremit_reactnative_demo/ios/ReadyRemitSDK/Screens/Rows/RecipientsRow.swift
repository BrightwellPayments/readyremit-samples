//
//  RecipientsRow.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 31/05/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//

import SwiftUI

struct RecipientsRow: View, AppearanceConsumer {
  var recipientsData: RecipientData
  var recipientsAccounts: [RecipientAccounts]
  var image: UIImage = UIImage(namedSdk: "right_arrow")!
  @ObservedObject var viewModel: RecipientsViewModel
  @Binding var isShowingCreateRecipient: Bool
  @State private var country: Country = Country(name: "", iso3Code: "")
  
  var body: some View {
    Spacer()
      .frame(width: UIScreen.main.bounds.size.width + 35, height: 2, alignment: .leading)
      .background(backgroundColorSecondary)
      .edgesIgnoringSafeArea(.all)
    VStack(alignment: .leading){
      Divider().padding(.top, 0)
      Text("\(recipientsData.lastName!), \(recipientsData.firstName!)")
        .font(labelName)
        .foregroundColor(textColorPrimaryShade4)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .padding(.leading)
        Divider()
        .frame(width: UIScreen.main.bounds.width)
      HStack {
          VStack(spacing: 0) {
            ForEach(recipientsAccounts, id: \.recipientAccountId) { i in
              HStack {
                VStack {
                  HStack{
                    FlagView(flagImage: FlagImage(currencyIso3Code: Constants.usdIso3Code), height: 15, width: 20)
                    Image(uiImage: image)
                      .frame(width: 10.67, height: 8, alignment: .center)
                    FlagView(flagImage: FlagImage(countryIso3Code: i.dstCountryIso3Code), height: 15, width: 20)
                  }
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding(.leading)
                  .padding(.top, 10)
                  let accountNumber: String = i.accountNumber ?? ""
                  let last4Digits: String = accountNumber != "" ? "****\(last4Digits(accountNumber))" : ""
                  Text("\(L10n.rrmBankTransfer)  \(last4Digits)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(labelType)
                    .foregroundColor(textPrimaryShade1)
                    .padding(.leading)
                    .padding(.bottom)
                    .padding(.top, -2)
                }

                NavigationLink(destination: TransferDetailsView(
                  model: viewModel.createRecipientModel,
                  isCountrySelected: true,
                  countrySelected: country,
                  recipientData: recipientsData,
                  recipientAccounts: i,
                  self.$isShowingCreateRecipient
                ),
                               isActive: $isShowingCreateRecipient) {
                  Button(L10n.rrmSendMoneyButton) {
                    let countryIso3Code = recipientsAccounts[0].dstCountryIso3Code
                    let selection = Bundle.sdk.decodeJson([CountryCallingCode].self, from: "CountryCallingCodes")
                    let filtered = selection.filter({ $0.iso3Code == countryIso3Code })

                    country = Country(name: filtered[0].name, iso3Code: countryIso3Code!)
                    UserDefaults.standard.set(country.name, forKey: "countrySelectedForDropdown")
                    
                    isShowingCreateRecipient = true
                  }
                  .buttonStyle(CallforactionButtonStyle(context: .borderless))
                  .frame(maxWidth: .infinity, alignment: .trailing)
                  .padding(.trailing, -60)
                }.isDetailLink(false)
                
              }
            }
          }
      }
      Divider().padding(.bottom, 0)
    }.background(backgroundColorSecondary)
  }
  
  
  func last4Digits(_ str: String) -> String {
    let last4 = String(str.suffix(4))
    return last4
  }
  
  var textColorPrimaryShade4: Color {
    Self.appearance.colors.textPrimaryShade4.color
  }
  var backgroundColorSecondary: Color {
    Self.appearance.colors.backgroundColorSecondary.color
  }
  var textPrimaryShade1: Color {
    Self.appearance.colors.textPrimaryShade1.color
  }
  var primaryShadeColor1: Color {
    Self.appearance.colors.primaryShade1.color
  }
  var buttonLabelsFont: Font {
    let spec = Self.appearance.fonts.subheadline
    return .font(spec: spec, style: .subheadline)
  }
  var labelType: Font {
    let spec = Self.appearance.fonts.footnote
    return .font(spec: spec, style: .footnote)
  }
  var labelName: Font {
    let spec = Self.appearance.fonts.headline
    return .font(spec: spec, style: .headline)
  }
}
