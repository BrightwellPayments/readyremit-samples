//
//  RecipientNameView.swift
//  RecipientNameView
//
//  Created by Mohan Reddy on 10/09/21.
//

import SwiftUI

struct TransparentGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: nil)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
            .overlay(configuration.label.padding(.leading, 4), alignment: .topLeading)
    }
}

struct RecipientNameView: View {
    
    @State var name: String?
    
    var body: some View {
        Group() {
          HStack {
            Text(name ?? "")
                .foregroundColor(Color(ReadyRemitAppearance.shared.titleColor))
                .font(Font(ReadyRemitAppearance.shared.pageTitleFont))
            Spacer()
              Button(action: {
                  print("menu clicked")
              }) {
                  Image("menu")
                              .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
              }
          }
          
        }
    }
}


struct RecipientNameView_Previews: PreviewProvider {

  static var previews: some View {
    RecipientNameView()
      .previewLayout(.sizeThatFits)
  }
}
