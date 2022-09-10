//
//  RecipientsViewModel.swift
//  ReadyRemitSDK
//
//  Created by Mohan Reddy on 15/09/21.
//

import Foundation
import Combine

class RecipientsViewModel: ObservableViewModel, RecipientService {
  internal let apiSession: ApiService
  @Published var recipientResponse: RecipientResponse?
  lazy var createRecipientModel = TransferDetailsViewModel(apiSession: apiSession)
  var cancellables = Set<AnyCancellable>()
  @Published var failure: ApiFailure? = nil

  init(apiSession: ApiService) {
    self.apiSession = apiSession
    print("RecipientsViewModel.init()")
    super.init()
  }

  func initializeCreateRecipientModel() {
    createRecipientModel.reload()
  }
  
  func fetchRecipients() {
    getRequestRecipient()
    .receive(on: RunLoop.main)
    .sink(
      receiveCompletion: { [weak self] in
        self?.isLoading = false
        if case let .failure(error) = $0 {
          self?.failure = error
        }
      },
      receiveValue: { [weak self] recipients in
        self?.recipientResponse = recipients
      }
    )
    .store(in: &cancellables)
  }
  
  func fetchSendersData() {
    getSendersData()
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { [weak self] in
          self?.isLoading = false
          if case let .failure(error) = $0 {
            self?.failure = error
          }
        },
        receiveValue: { senders in
          UserDefaults.standard.set(senders.kycStatus, forKey: "kycStatus")
        }
      )
      .store(in: &cancellables)
  }
}
