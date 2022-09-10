//
//  ListViewWithSearch.swift
//  ReadyRemitSDK
//
//  Created by Narendh on 29/09/21.
//

import Foundation
import SwiftUI

struct ListViewWithSearch: View {
    
    @Environment(\.presentationMode) var presentation
    @State  var searchText = ""
    @Binding var presentedAsModal: Bool
    @Binding var corridor: String?
    @State var list: [String] = []
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    SearchBarView(text: $searchText)
                        .padding(.top, 30)
                    
                    let filtered = list.filter({ searchText.isEmpty ? true : $0.contains((searchText)) })
                    ScrollView(.vertical, showsIndicators: false) {
                      ForEach(0..<filtered.count, id: \.self) { index in
                            HStack() {
                                Text(filtered[index])
                                    .font(Font(ReadyRemitAppearance.shared.fieldValueFont))
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                presentedAsModal = false
                                self.corridor = filtered[index]
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .navigationBarItems(
                    leading:
                        Button(action: {
                            self.presentation.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                                .foregroundColor(Color(ReadyRemitAppearance.shared.navigationCancelColor))
                                .font(Font(ReadyRemitAppearance.shared.navigationCancelFont))
                        }
                )
                .navigationBarTitle("", displayMode: .inline)
                .navigationViewStyle(StackNavigationViewStyle())
            }
            
        }
    }
}

struct ListViewWithSearch_Previews: PreviewProvider {
    
    @State static var presentedAsModal: Bool = false
    @State static var corridor: String? = ""
    
    static var previews: some View {
        ListViewWithSearch(presentedAsModal: $presentedAsModal, corridor: $corridor)
    }
}
