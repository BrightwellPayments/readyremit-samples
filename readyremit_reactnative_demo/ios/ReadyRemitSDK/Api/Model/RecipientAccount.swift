//
//  RecipientAccount.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/12/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation

struct RecipientAccount : Codable {
  let recipientAccountId: String
  let accountNumber: String
  let fields: [AdditionalField]
  
  // Force unwrapping these for now since we know we'll get them back.
  // These should be removed altogether though and field.value.getValue should be called instead
  func getIBAN() -> String {
    return fields.first { field in
      field.id == L10n.rrmCommonIBAN
    }!.value.getValue as! String
  }
  
  func getBIC() -> String {
    return fields.first { field in
      field.id == L10n.rrmCommonBIC
    }!.value.getValue as! String
  }
}


#if DEBUG

extension RecipientAccount {

  static func getRecipientAccountMock() -> RecipientAccount {
    let additionalFields = [AdditionalField(type: "TEXT",
                                            id: "IBAN",
                                            name: "IBAN",
                                            value: DynamicFieldValue(value: "GB52045123453339840520"))]
    return RecipientAccount(recipientAccountId: "4bb06c14-9433-40a0-81a6-ab58b22e7caa",
                            accountNumber: "GB52045123453339840520",
                            fields: additionalFields)
  }
}

#endif

