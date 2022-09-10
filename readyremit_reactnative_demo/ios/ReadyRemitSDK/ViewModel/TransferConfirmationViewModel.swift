//
//  TransferConfirmationViewModel.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/19/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation
import Combine


class TransferConfirmationViewModel: ObservableViewModel, TransferReviewService {
  
  @Published var failure: ApiFailure? = nil
  let recipientsListVM: RecipientsViewModel
  let transfer: Transfer
  let apiSession: ApiService
  var cancellables = Set<AnyCancellable>()
  @Published var confirmationTransfer: Transfer? = nil
  
  init(apiSession: ApiService, transfer: Transfer) {
    print("TransferReviewView.init()")
    self.apiSession = apiSession
    self.transfer = transfer
    self.recipientsListVM = RecipientsViewModel(apiSession: apiSession)
    super.init()
    self.isLoading = false
  }
  
  func loadTransfer() {
    let id: String = UserDefaults.standard.string(forKey: "transferId")!
    failure = nil
    getTransfer(id: id)
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { [weak self] in
          self?.isLoading = false
          if case let .failure(error) = $0 {
            self?.failure = error
          }
        },
        receiveValue: { [weak self] transfer in
          if let apiSession = self?.apiSession {
            self?.confirmationTransfer = TransferConfirmationViewModel(apiSession: apiSession, transfer: transfer).transfer
          }
        }
      )
      .store(in: &cancellables)
  }
}

