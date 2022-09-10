//
//  Sender.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 22/08/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//

import Foundation

struct SenderResponse: Codable {
  var senderId: String?
  var senderType: String?
  var firstName: String?
  var lastName: String?
  var kycStatus: String?
}
