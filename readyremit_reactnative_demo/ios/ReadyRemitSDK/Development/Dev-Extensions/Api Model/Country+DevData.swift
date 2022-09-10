//
//  Country+DevData.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import Foundation


extension Country {
  static var countries: [Country] {
    [Country(name: "Andorra", iso3Code: "AND"),
     Country(name: "Cyprus", iso3Code: "CYP"),
     Country(name: "Finland", iso3Code: "FIN"),
     Country(name: "France", iso3Code: "FRA"),
     Country(name: "Germany", iso3Code: "DEU"),
     Country(name: "Ghana", iso3Code: "GHA"),
     Country(name: "Indonesia", iso3Code: "IDN"),
     Country(name: "Italy", iso3Code: "ITA"),
     Country(name: "Mauritius", iso3Code: "MUS"),
     Country(name: "Puerto Rico", iso3Code: "PRI"),
     Country(name: "Australia", iso3Code: "AUS"),
     Country(name: "Belize", iso3Code: "BLZ"),
     Country(name: "Brazil", iso3Code: "BRA"),
     Country(name: "Korea (South)", iso3Code: "KOR")]
  }
}

#endif
