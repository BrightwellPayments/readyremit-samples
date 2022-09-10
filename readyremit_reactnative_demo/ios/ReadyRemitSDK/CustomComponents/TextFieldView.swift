//
//  TextFieldView.swift
//  TextFieldView
//
//  Created by Mohan Reddy on 13/09/21.
//

import SwiftUI

struct TextFieldView: View {
    
    @Binding var text: String

    var body: some View {
        TextField("", text: $text)
            .frame(height: 44)
            .padding(10)
    }
}

struct TextFieldView_Previews: PreviewProvider {
    
    @State static var amount: String = "0"
    
    static var previews: some View {
        TextFieldView(text: $amount)
            .previewLayout(.sizeThatFits)
    }
}
