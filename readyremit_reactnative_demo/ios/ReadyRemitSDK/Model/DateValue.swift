//
//  DateValue.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 3/16/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation


class DateValue: ObservableValue {
  
  static let maxDay: Int = 31
  static let maxYear: Int = 2100
  
  override init () {}
  
  init(day: String = "", month: Month? = nil, year: String = "") {
    self.day = day
    self.month = month
    self.year = year
  }
  
  @Published var day: String = "" {
    willSet {
      if !didChange {
        didChange = day != newValue
      }
    }
  }
  @Published var month: Month? {
    willSet {
      if !didChange {
        didChange = month != newValue
      }
    }
  }
  @Published var year: String = "" {
    willSet {
      if !didChange {
        didChange = year != newValue
      }
    }
  }
  
  func validate() -> ValidationResult {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MMMM-dd"
    var messages = [String]()
    if month == nil { messages.append(L10n.rrmErrorMonth) }
    if let date = dateFormatter.date(from:"\(year)-\(month?.name ?? "")-\(day)"),
       year.count == 4 {
      print(date)
      return .success
    }
    else {
      if (year.isEmpty || day.isEmpty || Int(day) == 0 || Int(year) == 0) {
        messages.append(L10n.rrmErrorEmptyNumber)
      }
      if (year.count < 4) { messages.append(L10n.rrmErrorYear) }
      if messages.isEmpty {
        messages.append(L10n.rrmErrorInvalidDate)
      }
      return .fail(messages)
    }
  }
}
