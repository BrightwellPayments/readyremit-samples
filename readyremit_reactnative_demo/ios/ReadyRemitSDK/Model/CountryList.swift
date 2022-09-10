//
//  Country.swift
//  ReadyRemitSDK
//
//  Created by Mohan Reddy on 15/09/21.
//

import Foundation

struct CountryListResponse: Decodable {
    var result: CountryListResult
}

struct CountryListResult: Decodable {
    var step: String?
    var corridors: [Corridor]?
}

struct Corridor: Decodable {
  var destinationCountry: Country
  var sourceCurrency: [Currency]
  var destinationCurrency: [Currency]
  var transferMethod: String
}

struct CurrencyISOCode: Codable {
    var isoCode: String?
    var limit: Int?
}
