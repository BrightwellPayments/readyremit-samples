//
//  HorizontalTextScrollView.swift
//  HorizontalTextScrollView
//
//  Created by Mohan Reddy on 14/09/21.
//

import SwiftUI

struct HorizontalTextScrollView: View {
    
    @State var titles: [String] = []
    @Binding var selectedIndex: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                FieldLabel(title: "Recipient type", required: true)
                HStack(spacing: 12) {
                  ForEach(0..<titles.count, id: \.self) {index in
                        if selectedIndex == index {
                            Button {
                                self.selectedIndex = index
                            } label: {
                                Text("\(titles[index])      ")
                            }
                            .foregroundColor(Color(ReadyRemitAppearance.shared.titleColor))
                            .font(Font(ReadyRemitAppearance.shared.highlightedCapsuleFont))
                            .multilineTextAlignment(.center)
                            .frame(height:34)
                            .background(
                                CapsuleFilledView()
                            )
                        } else {
                            Button {
                                self.selectedIndex = index
                            } label: {
                                Text("\(titles[index])      ")
                            }
                            .foregroundColor(Color(ReadyRemitAppearance.shared.currencyDisableColor))
                            .font(Font(ReadyRemitAppearance.shared.disabledCapsuleFont))
                            .multilineTextAlignment(.center)
                            .frame(height:34)
                            .background(
                                CapsuleUnfilledView()
                            )
                        }
                    }
                }
            }
        }
    }
}

struct HorizontalTextScrollView_Previews: PreviewProvider {
    
    @State static var selectedIndex: Int = -1
    
    static var previews: some View {
        HorizontalTextScrollView(selectedIndex: $selectedIndex)
    }
}

struct CapsuleFilledView: View {
    var body: some View {
        Capsule()
            .strokeBorder(Color.black, lineWidth: 1.5)
            .background(
                Capsule().fill(Color(ReadyRemitAppearance.shared.highlightedBackgroundColor))
            )
    }
}

struct CapsuleUnfilledView: View {
    var body: some View {
        Capsule()
            .strokeBorder(Color(ReadyRemitAppearance.shared.fieldBorderColor), lineWidth: 1.5)
    }
}
