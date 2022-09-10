//
//  RecipientFields.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 15/06/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//

import Foundation
import SwiftUI

struct GetRecipientFields: Codable {
  var fieldSets: [FieldSets]
}

struct FieldSets: Codable {
  var fieldSetId: String?
  var fieldSetName: String?
  var fields: [RecipientFields]?
}

struct RecipientFields: Codable {
  var fieldType: String?
  var options: [OptionsSet]?
  var optionsSource: String?
  var minLength: Int?
  var maxLength: Int?
  var regex: String?
  var fieldId: String?
  var name: String?
  var hintText: String?
  var isRequired: Bool?
  var placeholderText: String?
}

struct OptionsSet: Codable, Identifiable, Filterable {
  var id: String?
  var name: String?
  
  func matches(lowercasedFilter: String) -> Bool {
    name!.lowercased().contains(lowercasedFilter)
  }
}

extension OptionsSet : ListRowProvider {
  @ViewBuilder func row() -> some View {
    HStack() {
      Text(name!)
      Spacer()
    }
  }
}
