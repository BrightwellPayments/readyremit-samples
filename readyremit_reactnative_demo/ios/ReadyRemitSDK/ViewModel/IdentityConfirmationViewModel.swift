//
//  IdentityConfirmationViewModel.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 30/08/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//

import Foundation
import Combine

class IdentityConfirmationViewModel: ObservableViewModel, IdentityConfirmationService {
  func sendValidationData(params: [String: String], senderId: String) {}
  let apiSession: ApiService
  var cancellables = Set<AnyCancellable>()
  @Published var loading: Bool = false
  @Published var failure: ApiFailure? = nil
  @Published var processIsDone: Bool = false
  
  init(apiSession: ApiService) {
    self.apiSession = apiSession
    super.init()
  }
  
  func sendIdentityData(
    identityValidationModel: [String: String],
    senderId: String
  ) {
    sendValidationData(params: identityValidationModel, senderId: senderId)
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: {[weak self] in
          self?.loading = false
          if case let .failure(error) = $0 {
            self?.failure = error
          }
        },
        receiveValue: {[weak self] _ in
          self?.processIsDone = true
          UserDefaults.standard.set(true, forKey: "imagesAreDone")
          UserDefaults.standard.removeObject(forKey: "kycStatus")
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self?.loading = false
          }
        }).store(in: &cancellables)
  }
}
