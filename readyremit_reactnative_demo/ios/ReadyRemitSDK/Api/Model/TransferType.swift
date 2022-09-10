//
//  TransferType.swift
//  ReadyRemitSDK
//
//  Copyright © 2022 Brightwell. All rights reserved.
//

import Foundation
import SwiftUI


struct TransferTypeParams : Encodable {

  let srcCurrencyIso3Code: String
  let dstCurrencyIso3Code: String
  let dstCountryIso3Code: String
}

struct TransferType : Decodable, Identifiable, Filterable {
  let name: TransferName
  let id: TransferId
  
  enum TransferName: String, Decodable {
    case bankTransfer = "Bank Transfer"
  }
  enum TransferId: String, Decodable {
    case bankTransfer = "BANK_TRANSFER"
  }
  
  func matches(lowercasedFilter: String) -> Bool {
    name.rawValue.lowercased().contains(lowercasedFilter)
  }
}

extension TransferType : ListRowProvider {

  @ViewBuilder func row() -> some View {
    HStack() {
      Text(name.rawValue)
      Spacer()
    }
  }
}

#if DEBUG

extension TransferType {
  static var transactionTypes: [TransferType] {
    [TransferType(name: .bankTransfer, id: .bankTransfer)]
  }
}

#endif
