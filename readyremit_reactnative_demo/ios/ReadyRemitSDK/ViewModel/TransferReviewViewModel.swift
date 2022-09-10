//
//  TransferReviewViewModel.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/12/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation
import Combine


class TransferReviewViewModel: ObservableViewModel, TransferReviewService {
  
  private static let termsOfUseURL = "https://www.brightwell.com/readyremit/terms-of-use"
  private static let privacyPolicyURL = "https://www.brightwell.com/readyremit/privacy-policy"
  @Published var failure: ApiFailure? = nil
  var transferSubmitted: Bool = false
  let quote: Quote
  let dstCountry: Country
  let dstCurrency: Currency
  let newRecipient: CreateRecipient
  let newRecipientAccount: RecipientAccount
  var confirmationViewModel: TransferConfirmationViewModel?
  var apiSession: ApiService
  var cancellables = Set<AnyCancellable>()
  
  init(apiSession: ApiService, quote: Quote, dstCountry: Country, recipient: CreateRecipient, bankDetails: RecipientAccount, dstCurrency: Currency) {
    print("TransferReviewView.init()")
    self.apiSession = apiSession
    self.quote = quote
    self.dstCountry = dstCountry
    self.dstCurrency = dstCurrency
    self.newRecipient = recipient
    self.newRecipientAccount = bankDetails
    super.init()
    self.isLoading = false
  }
  
  func getTermsOfUseAndPolicyContents() -> [AttributedTextType] {
    return [.text(""),
            .link(
              text: "",//L10n.readyRemitTransferReviewDisclaimerTerms,
              url: TransferReviewViewModel.termsOfUseURL),
            .text(""),
            .link(
              text: "",//L10n.readyRemitTransferReviewDisclaimerPolicy,
              url: TransferReviewViewModel.privacyPolicyURL)]
  }
  
  func submitTransfer(success: @escaping () -> Void) {
    failure = nil
    guard let sendAmount = Decimal(string: quote.getSendAmount()) else {
      failure = .failure([ApiError(message: "Unable to retrieve send amount from quote.",
                                   description: "Send Amount Missing",
                                   fieldId: "",
                                   code: "")])
      return
    }
    
    let converted = sendAmount * 100
    let intConverted = NSDecimalNumber(decimal: converted).intValue
    let request: ReadyRemit.TransferRequest = ReadyRemit.TransferRequest(dstCountryIso3Code: dstCountry.iso3Code,
                                                                         dstCurrencyIso3Code: dstCurrency.iso3Code,
                                                                         srcCurrencyIso3Code: Constants.usdIso3Code,
                                                                         transferMethod: Constants.bankAccountType,
                                                                         quoteBy: Quote.QuoteType.sendAmount.rawValue,
                                                                         amount: intConverted,
                                                                         fee: quote.getTransferFee(),
                                                                         // senderId will be removed in future API update
                                                                         senderId: "e087b0da-6238-46e7-b749-43331451c3f6",
                                                                         recipientId: newRecipient.recipientId,
                                                                         recipientAccountId: newRecipientAccount.recipientAccountId,
                                                                         // puposeOfRemittance will be removed in future API update
                                                                         purposeOfRemittance: "1")
    isLoading = true
    transferSubmitted = true
    ReadyRemit.shared.submitTransfer(transferRequest: request) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let transferId):
          UserDefaults.standard.set(transferId, forKey: "transferId")
          success()
        case .failure(let failure):
          self.failure = failure
          self.isLoading = false
        }
      }
    }
  }
}

