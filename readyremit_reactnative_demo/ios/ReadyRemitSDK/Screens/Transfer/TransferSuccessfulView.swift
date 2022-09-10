//
//  TransferSuccessfulView.swift
//  TransferSuccessfulView
//
//  Created by Mohan Reddy on 12/09/21.
//

import SwiftUI
import UIKit

struct TransferSuccessfulView: View {
    
    @State var amount: String = "--"
    @State var recipientName: String = "--"
    
    var body: some View {
        VStack(alignment:.center, spacing: 0) {
            Divider()
                .background(Color(ReadyRemitAppearance.shared.dividerColor))
                .frame(height: 1)
            VStack {
                ZStack {
                    Circle()
                        .fill(Color(UIColor(hex: "34C759")))
                        .frame(width: 32, height: 32)
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.white)
                        .imageScale(.small)
                }
                .padding(.top, 32)
                .padding(.bottom, 12)
                Text("Transfer Successfull!")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.bottom, 32)
                Divider()
                    .background(Color(ReadyRemitAppearance.shared.dividerColor))
                    .frame(height: 1)
                    .padding(.bottom, 32)
                let text = Text("You have successfully sent ") + Text(amount).bold() + Text(" INR") + Text(" to ") + Text(recipientName).bold() + Text(" via bank transfer.")
                text.multilineTextAlignment(.center).font(.footnote).padding(.bottom, 16)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(alignment:.center, spacing: 2) {
                    Text("Confirmation:").font(.footnote)
                    Text("#2446788").font(.footnote).bold()
                    Text(" ")
                    Button(action: {
                        print("view Clicked")
                    }) {
                        Text("View receipt").font(.footnote).bold()
                    }
                }
                .padding(.bottom, 32)
                Divider()
                    .background(Color(ReadyRemitAppearance.shared.dividerColor))
                    .frame(height: 1)
                    .padding(.bottom, 32)
            }
            
            Text("Times may vary, but we estimate \(recipientName) will receive the money same business day.").multilineTextAlignment(.center)
                .font(.footnote).padding(.top, 10)
            
            Spacer()
          Button("Send another transfer") {
            print("Success > another transfer")
          }
          .buttonStyle(CallforactionButtonStyle())
          .padding(.bottom, 12)

          Button("Back to {client.app}") {
            print("Success > back to hosting app")
          }
          .buttonStyle(CallforactionButtonStyle(context: .secondary))
        }
        .navigationBarTitle(Text("Confirmation"), displayMode: .inline)
        .padding(.horizontal, 16)
        .navigationBarBackButtonHidden(true)
    }
}


#if DEBUG

struct TransferSuccessfulView_Previews: PreviewProvider {
    static var previews: some View {
        TransferSuccessfulView()
    }
}

#endif
