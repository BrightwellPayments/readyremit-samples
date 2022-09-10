//
//  TransferCardDetailsView.swift
//  TransferCardDetailsView
//
//  Created by Mohan Reddy on 10/09/21.
//

import SwiftUI

struct TransferCardDetailsRow: View {
    
    @State var recipient: Recipient?
    
    var body: some View {
        if let recipient = recipient {
            VStack(spacing:0) {
                Text("").frame(minWidth:0, maxWidth: nil, minHeight: 20, maxHeight: 20, alignment: .center).background(Color.gray).opacity(0.1)
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 0.4)
                RecipientNameView(name: recipient.name).padding(.horizontal, 10)
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 0.4)
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 0.4)
            }
        }
    }
}

struct TransferCardDetailsRow_Previews: PreviewProvider {
    static var previews: some View {
        TransferCardDetailsRow()
            .previewLayout(.sizeThatFits)
    }
}
