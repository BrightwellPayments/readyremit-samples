//
//  TextFieldWithTitleView.swift
//  ReadyRemitSDK
//
//  Created by Mohan Reddy on 24/09/21.
//

import SwiftUI

struct TextFieldWithTitleView: View {
    
    @State var isRequired: Bool = false
    @State var title: String = ""
    @Binding var text: String
    @State var showRemove: Bool = false
    @State var didSelectRemove: (() -> Void)?
    @State var showLightText: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                FieldLabel(title: title, required: isRequired)
                Spacer()
                if showRemove {
                    Text("Remove")
                        .font(Font(ReadyRemitAppearance.shared.highlightedCapsuleFont))
                        .foregroundColor(Color(ReadyRemitAppearance.shared.removeColor))
                        .onTapGesture {
                            didSelectRemove?()
                        }
                }
            }
            TextFieldView(text: $text)
                .border(Color(ReadyRemitAppearance.shared.fieldBorderColor), width: 1)
        }
    }
}

struct TextFieldWithTitleView_Previews: PreviewProvider {
    
    @State static var text: String = ""
    
    static var previews: some View {
        TextFieldWithTitleView(text: $text, didSelectRemove: {})
    }
}
