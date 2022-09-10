//
//  CountryCallingCodeValue.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 3/25/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation
import SwiftUI


struct CountryCallingCode: Decodable, Filterable, Identifiable {
  var id: String { iso3Code }
  
  let name: String
  let iso3Code: String
  let callingCode: String
  
  func matches(lowercasedFilter: String) -> Bool {
    name.lowercased().contains(lowercasedFilter) || callingCode.contains(lowercasedFilter)
  }
}

extension CountryCallingCode: ListRowProvider {

  @ViewBuilder func row() -> some View {
    HStack() {
      FlagView(flagImage: FlagImage(countryIso3Code: iso3Code))
      Text(name)
      Spacer()
      Text(callingCode)
    }
  }
}


class CountryCallingCodeValue: ObservableValue {
 
  @Published var countryCallingCode: CountryCallingCode? = nil
  @Published var phoneNumber: String = "" {
    willSet {
      if !didChange {
        didChange = phoneNumber != newValue
      }
    }
  }
  
  public var validPhoneNumber: ValidationResult {
    let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
    guard let detector = try? NSDataDetector(types: types.rawValue) else { preconditionFailure() }
    if let match = detector.matches(in: phoneNumber, options: [], range: NSMakeRange(0, phoneNumber.count)).first?.phoneNumber {
      return match == phoneNumber ? .success : .fail(["Phone number is invalid"])
    } else {
      return .fail([L10n.rrmErrorEmptyDynamicField("Phone number")])
    }
  }
}
