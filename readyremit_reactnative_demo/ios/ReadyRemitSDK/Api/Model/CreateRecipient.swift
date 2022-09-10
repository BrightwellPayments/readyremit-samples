//
//  CreateRecipient.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/9/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation


struct CreateRecipient : Decodable {
  let recipientId: String
  let senderId: String
  let recipientType: String
  let firstName: String
  let lastName: String
  let fields: [AdditionalField]
}


#if DEBUG

extension CreateRecipient {

  static func getCreateRecipientMock() -> CreateRecipient {
    let additionalFields = [AdditionalField(type: "TEXT",
                                            id: "FIRST_NAME",
                                            name: "First name",
                                            value: DynamicFieldValue(value: "MR"))]
    return CreateRecipient(recipientId: "566",
                           senderId: "mock",
                           recipientType: "PERSON", 
                           firstName: "MR",
                           lastName: "T",
                           fields: additionalFields)
  }
}

#endif
