//
//  RecipientsList.swift
//  RecipientsList
//
//  Created by Mohan Reddy on 10/09/21.
//
import Foundation
import SwiftUI
import UIKit

public struct RecipientsListView: View, AppearanceConsumer {
  
  private let onLaunch: (() -> Void)?
  @State private var hasPerformedOnLaunch = false
  private let dismissAction: (() -> Void)?
  @ObservedObject var viewModel: RecipientsViewModel
  @State private var isShowingCreateRecipient = false
  @State private var showVerifyButton = false
  
  @Environment(\.presentationMode) var presentation
  @State var isAddNewClicked = false
  
  internal init(model: RecipientsViewModel,
                onLaunch: (() -> Void)? = nil,
                onDismiss: (() -> Void)? = nil
  ) {
    self.viewModel = model
    self.onLaunch = onLaunch
    self.dismissAction = onDismiss
  }
  
  public var body: some View {
    NavigationView {
      ZStack(alignment: .bottom) {
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 0) {
            if let recipients = viewModel.recipientResponse?.recipients {
              ScrollView {
                if #available(iOS 14.0, *) {
                  LazyVStack {
                    let filtered: [RecipientData] = recipients.filter { $0.recipientAccounts.count > 0 }
                    ForEach(filtered, id: \.recipientId) { i in
                      RecipientsRow(
                        recipientsData: i,
                        recipientsAccounts: i.recipientAccounts,
                        viewModel: viewModel,
                        isShowingCreateRecipient: self.$isShowingCreateRecipient)
                    }
                  }
                }
              }
              .frame(height: UIScreen.main.bounds.size.height)
              .background(backgroundColorPrimary)
            }else {
              Spacer()
              Text(L10n.rrmNoRecipients)
                .font(labelsFont)
                .foregroundColor(textColorPrimaryShade4)
                .frame(maxWidth: .infinity)
              Spacer()
              
            }
          }
        }
        .navigationBarTitle(Text(L10n.rrmRecipientsListTitle), displayMode: .inline)
        .navigationBarItems(
          leading:
            Button("Host App") { self.presentation.wrappedValue.dismiss() }
            .buttonStyle(CallforactionButtonStyle(context: .borderless))
            .padding(.leading, -30)
            .padding(.trailing, -30)
          ,
          trailing:
            HStack {
              NavigationLink(destination: TransferDetailsView(model: viewModel.createRecipientModel, isCountrySelected: false, self.$isAddNewClicked).navigationBarTitle(L10n.rrmTransferDetails),
                             isActive: $isAddNewClicked){
                Button(L10n.rrmAddNewButton) { isAddNewClicked = true }
                  .buttonStyle(CallforactionButtonStyle(context: .borderless))
                  .padding(.trailing, -40)
              }.isDetailLink(false)
              NavigationLink(destination: TransferDetailsView(model: viewModel.createRecipientModel, isCountrySelected: false, self.$isShowingCreateRecipient),
                             isActive: $isShowingCreateRecipient){
                Button("+") {
                  showCreateRecipient()
                }
                  .buttonStyle(CallforactionButtonStyle(context: .borderless))
                  .padding(.leading, -30)
                  .padding(.trailing, -30)
              }.isDetailLink(false)
            }
        )
        .onAppear {
          if !hasPerformedOnLaunch {
            onLaunch?()
            hasPerformedOnLaunch = true
          }
          viewModel.fetchRecipients()
          viewModel.fetchSendersData()
          UserDefaults.standard.set(true, forKey: "recipientDetailsApi")
          UserDefaults.standard.set("", forKey: "countrySelectedForDropdown")
          UserDefaults.standard.set(true, forKey: "recipientAccountsApi")
        }
        .background(backgroundColorPrimary)
        
        if viewModel.isLoading {
          LoadingIndicatorView()
        }
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .navigationBarHidden(true)
    .accentColor(primaryShadeColor)
  }

  
  private func showCreateRecipient() {
    viewModel.initializeCreateRecipientModel()
    isShowingCreateRecipient = true
  }
  var textColorPrimaryShade4: Color {
    Self.appearance.colors.textPrimaryShade4.color
  }
  var primaryShadeColor: Color {
    Self.appearance.colors.primaryShade1.color
  }
  var navBarItemColor: Color {
    Self.appearance.navigationColor.color
  }
  var backgroundColorPrimary: Color {
    Self.appearance.colors.backgroundColorPrimary.color
  }
  var labelsFont: Font {
    let spec = Self.appearance.textfieldSubtitleFont
    return .font(spec: spec, style: .headline)
  }
}


#if DEBUG

struct RecipientsListView_Previews: PreviewProvider {
  
  static let token = OAuthToken(tokenType: "token",
                                           accessToken: "access",
                                           expiresInSeconds: 300)
  static let tokenStore = AuthTokenStore(authToken: token)
  static let session = ApiSession(environment: ApiEnvironment.mock, authTokenStore: tokenStore)
  static let model = RecipientsViewModel(apiSession: session)
  
  static var previews: some View {
    Group {
      RecipientsListView(model: model, onLaunch: nil, onDismiss: nil)
      RecipientsListView(model: model, onLaunch: nil, onDismiss: nil)
        .environment(\.locale, .init(identifier: "de"))
    }.previewLayout(.sizeThatFits)
  }
}

#endif
