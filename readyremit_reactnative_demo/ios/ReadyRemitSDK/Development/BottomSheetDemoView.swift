//
//  BottomSheetDemoView.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 4/15/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
#if DEBUG

import SwiftUI


struct BottomSheetDemoView: View {
  
  class Model : ObservableObject {
    @Published var selection: Int
    
    init() {
      selection = 0
    }
  }
  
  @State var showSheet = false
  @State var fieldValue = PickerFieldValue<Country>(field: Field(id: "id1",
                                                                 label: "Countries",
                                                                 required: false,
                                                                 placeholder: "One",
                                                                 info: "4 Countries"),
                                                    value: nil)
  @ObservedObject private var model: Model = Model()
  let info = "Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32.  The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham."
  
  var body: some View {
    VStack(spacing: 16) {
      Button("small - title - action - info") {
        showSheetWithID(id: 0)
      }
      .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
      Button("medium - title - no action - info") {
        showSheetWithID(id: 1)
      }
      .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
      Button("large - no title - action - info") {
        showSheetWithID(id: 2)
      }
      .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
      Button("medium - title - action - selection list") {
        showSheetWithID(id: 3)
      }
      .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
      Button("small - selection list only") {
        showSheetWithID(id: 4)
      }
      .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
    }
    .sheet(isPresented: $showSheet,
           onDismiss: { showSheet = false },
           content: {
      switch model.selection {
      case 0:
        BottomInfoSheet(sheetSize: .small,
                        title: "small - info",
                        labelAction: ("Action", action),
                        info: info)
      case 1:
        BottomInfoSheet(sheetSize: .medium,
                        title: "medium - info",
                        info: info)
      case 2:
        BottomInfoSheet(sheetSize: .large,
                        title: nil,
                        labelAction: ("Action", action),
                        info: info)
      case 3:
        BottomSelectionSheet(sheetSize: .medium,
                             title: "medium - selection list",
                             labelAction: ("Action", action),
                             selection: BottomSheet_Previews.countries,
                             fieldValue: $fieldValue) { country in
          country.name
        }
      case 4:
        BottomSelectionSheet(sheetSize: .small,
                             selection: BottomSheet_Previews.countries,
                             fieldValue: $fieldValue) { country in
          country.name
        }
      default:
        BottomInfoSheet(sheetSize: .medium,
                        title: nil,
                        info: nil)
      }
    })
  }
  
  func showSheetWithID(id: Int) {
    showSheet = true
    model.selection = id
  }
  
  func action() {
    showSheet = false
  }
}

#endif
