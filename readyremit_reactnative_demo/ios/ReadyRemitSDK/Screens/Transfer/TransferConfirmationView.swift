//
//  TransferConfirmationView.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 4/25/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI


struct TransferConfirmationView: View, AppearanceConsumer {
  @ObservedObject var model: TransferConfirmationViewModel
  @State private var showRecipientsList = false
  @State private var presentingModal = false
  @Binding var rootIsActive: Bool
  @Binding var transferIsActive: Bool
  
  var body: some View {
    GeometryReader { geometry in
      VStack(alignment: .center, spacing: 24) {
        ZStack {
          Circle()
            .fill(checkmarkIconColor)
            .frame(width: 32, height: 32)
          Image(systemName: "checkmark")
            .foregroundColor(Color.white)
            .imageScale(.small)
        }
        .padding(.top, 52)
        Text(L10n.rrmTransSubmittedTitle)
          .font(headerFont)
          .foregroundColor(inputColor)
        Divider()
          .padding(.horizontal, 16)
        
        if let isConfirmationTransfer = model.confirmationTransfer {
          if !isConfirmationTransfer.recipientDetails.firstName.isEmpty {
            VStack(spacing: 16) {
              Text(L10n.rrmTransSubmittedDetailsMessage(
                isConfirmationTransfer.quote.getReceiveAmount(decimalPlaces: isConfirmationTransfer.quote.receiveAmount.currency.decimalPlaces),
                isConfirmationTransfer.quote.receiveAmount.currency.iso3Code,
                isConfirmationTransfer.recipientDetails.firstName,
                isConfirmationTransfer.recipientDetails.lastName,
                L10n.rrmBankTransferScreenTitle))
                .multilineTextAlignment(.center)
                .font(inputFont)
                .foregroundColor(inputColor)
              Text("\(L10n.rrmConfirmationNumberLabel) **#\(isConfirmationTransfer.confirmationNumber)**")
                .font(inputFont)
                .foregroundColor(inputColor)
            }.padding(.horizontal, 16)
            Button(L10n.rrmViewReceiptLink) { self.presentingModal = true }
              .buttonStyle(CallforactionButtonStyle(context: .borderless))
              .padding(.top, -30)
              .padding(.bottom, -20)
            NavigationLink(destination: TransferReceiptView(transfer: model.confirmationTransfer!).navigationBarBackButtonHidden(true),
                           isActive: $presentingModal) {
              EmptyView()
            }.isDetailLink(false)
            Divider()
              .padding(.horizontal, 16)
            Text(L10n.rrmSlaDisclaimerTextWithName(
              "\(isConfirmationTransfer.recipientDetails.firstName) \(isConfirmationTransfer.recipientDetails.lastName)",
              isConfirmationTransfer.quote.deliverySLA.name))
              .font(inputFont)
              .foregroundColor(inputColor)
              .padding(.horizontal, 16)
          }
        }
        Spacer()
        VStack(spacing: 13) {
          Button(L10n.rrmDoneButton) {
            let transferDetailsViewModel = TransferDetailsViewModel(apiSession: model.apiSession)
            transferDetailsViewModel.restoreData { _ in }
            self.transferIsActive = false
            self.rootIsActive = false
          }
            .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
        }
        .padding(.bottom, 10)
      }
      .alertApiFailure($model.failure) {
        model.loadTransfer()
      }
      .background(backgroundPageColor)
    }
    .navigationBarTitle(Text(L10n.rrmTransferConfirmationTitle),
                        displayMode: .inline)
    .navigationBarBackButtonHidden(true)
    .onAppear(perform: model.loadTransfer)
  }
  
  var backgroundPageColor: Color {
    Self.appearance.colors.backgroundColorPrimary.color
  }
  var checkmarkIconColor: Color {
    Self.appearance.inputStyle.borderColorSuccess?.color ?? Self.appearance.colors.success.color
  }
  var inputFont: Font {
    let spec = Self.appearance.inputStyle.inputFontSpec ?? Self.appearance.fonts.body
    return .font(spec: spec, style: .body)
  }
  var headerFont: Font {
    let spec = Self.appearance.textfieldSubheadlineFont
    return .font(spec: spec, style: .headline).bold()
  }
  var inputColor: Color {
    Self.appearance.inputStyle.inputFontColor?.color ??
    Self.appearance.colors.textPrimaryShade4.color
  }
}


#if DEBUG

struct TransferConfirmationView_Previews: PreviewProvider {
  
  static let token = OAuthToken(tokenType: "token",
                                accessToken: "access",
                                expiresInSeconds: 600)
  static let tokenStore = AuthTokenStore(authToken: token)
  static let session = ApiSession(environment: ApiEnvironment.mock, authTokenStore: tokenStore)
  static let model = TransferConfirmationViewModel(apiSession: session,
                                                   transfer: Transfer.mock)
  
  static var previews: some View {
    TransferConfirmationView(model: model, rootIsActive: Binding.constant(false), transferIsActive: Binding.constant(false))
  }
}

#endif
