//
//  Month.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 3/16/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation
import SwiftUI


struct Month: Equatable {

  let name: String
}


//MARK: - Month + DropDownList

extension Month : Identifiable {

  var id: String { name }
}


extension Month : Filterable {

  func matches(lowercasedFilter: String) -> Bool {
    name.lowercased().contains(lowercasedFilter)
  }
}


extension Month : ListRowProvider {

  @ViewBuilder func row() -> some View {
    HStack() {
      Text(name)
        .font(itemFont)
        .foregroundColor(itemColor)
        .padding(.vertical, 2)
      Spacer()
    }
  }
  
  var itemFont: Font {
    let spec = ReadyRemit.shared.appearance.dropdownListStyle.itemFontSpec ?? ReadyRemit.shared.appearance.fonts.callout
    return .font(spec: spec, style: .callout)
  }
  var itemColor: Color {
    ReadyRemit.shared.appearance.dropdownListStyle.itemFontColor?.color ?? ReadyRemit.shared.appearance.colors.textPrimaryShade4.color
  }
}
