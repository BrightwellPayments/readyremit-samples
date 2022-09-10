//
//  Country.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

import SwiftUI
import Foundation


struct Country : Decodable {
  let name: String
  let iso3Code: String
}

extension Country : Identifiable {

  var id: String { iso3Code }
}


extension Country : Filterable {

  func matches(lowercasedFilter: String) -> Bool {
    name.lowercased().contains(lowercasedFilter)
  }
}


extension Country : ListRowProvider {

  @ViewBuilder func row() -> some View {
    HStack(spacing: 16) {
      FlagView(flagImage: FlagImage(countryIso3Code: iso3Code))
      Text(name)
      Spacer()
    }
  }
}

#if DEBUG

extension Country {
  static let mock = Country(name:"", iso3Code: "USA")
}

#endif
