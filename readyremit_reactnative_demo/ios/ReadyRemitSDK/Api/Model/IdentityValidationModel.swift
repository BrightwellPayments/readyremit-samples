//
//  IdentityValidationModel.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 30/08/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//

import Foundation

struct IdentityValidationModel: Codable {
  var countryCode: String?
  var image: String?
  var backImage: String?
  var selfieImage: String?
  var idType: String?
}
