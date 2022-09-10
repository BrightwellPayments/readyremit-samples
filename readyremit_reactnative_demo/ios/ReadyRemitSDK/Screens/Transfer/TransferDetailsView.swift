//
//  TransferDetailsView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Combine
import SwiftUI
#if !targetEnvironment(simulator)
import ScanForensicsPlus
import AcuantCommon
import AcuantCamera
import AcuantFaceCapture
import AcuantImagePreparation
import AcuantPassiveLiveness
#endif
struct TransferDetailsView : View, AppearanceConsumer {
  
  @ObservedObject var model: TransferDetailsViewModel
  var isCountrySelected: Bool
  var countrySelected: Country?
  var recipientData: RecipientData?
  var recipientAccounts: RecipientAccounts?
  @State var invalidFields: [String] = []
  @State var transferDetailsIsActive = false
  @Binding var rootIsActive: Bool
  @State private var goToIDology = false
  #if !targetEnvironment(simulator)
  private let sfpc = ScanForensicsPlusController()
  #endif
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  init(
    model: TransferDetailsViewModel,
    isCountrySelected: Bool,
    countrySelected: Country? = nil,
    recipientData: RecipientData? = nil,
    recipientAccounts: RecipientAccounts? = nil,
    _ rootIsActive: Binding<Bool>
  ) {
    self.model = model
    self.isCountrySelected = isCountrySelected
    self.countrySelected = countrySelected ?? Country(name: "", iso3Code: "")
    self.recipientData = recipientData
    self.recipientAccounts = recipientAccounts
    _rootIsActive = rootIsActive
    
    let countryName: String = "\(countrySelected?.name ?? "")"
    self.model.countrySelected = countryName
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        ScrollView {
          ZStack {
            VStack(alignment: .leading, spacing: 16) {
              ZStack {
                VStack(spacing: 16) {
                  Divider()
                  LinePickerField(selection: model.countries,
                                  fieldValue: $model.selectedDstCountryFieldValue,
                                  textToDisplay: { country in
                    country.name
                  }).padding(.vertical, 20)
                  if !model.transferTypes.isEmpty,
                     let srcCurrency = model.selectedSrcCurrencyValue.value.currency,
                     let corridor = model.corridors?.first {
                    LinePickerField(selection: model.transferTypes,
                                    fieldValue: $model.selectedTransferTypeFieldValue,
                                    textToDisplay: { transferType in
                      return transferType.name.rawValue
                    })
                    .padding(.bottom, 20)
                    
                    FieldInputCurrency(selection: [srcCurrency],
                                       fieldValue: $model.selectedSrcCurrencyValue,
                                       isLoading: $model.isLoading,
                                       isDisabled: $model.enabled)
                    .id(model.selectedSrcCurrencyValue.fieldReadonlyData.name)
                    
                    ExchangeRateLabelView(srcCurrencyIsoCode: srcCurrency.iso3Code,
                                          dstCurrencyIsoCode: model.selectedDstCurrencyValue.value.currency?.iso3Code ?? "",
                                          transferRate: $model.transferRate)
                    
                    FieldInputCurrency(selection:  corridor.destinationCurrency,
                                       fieldValue: $model.selectedDstCurrencyValue,
                                       isLoading: $model.isLoading,
                                       isDisabled: $model.disabled)
                    .id(model.selectedDstCurrencyValue.fieldReadonlyData.name)
                    .padding(.bottom, 8)
                    
                    VStack(spacing:8) {
                      HorizontalTextView(leftLabel:L10n.rrmTransferFee,
                                         value: $model.transferFee,
                                         rightLabel: srcCurrency.iso3Code,
                                         leftLabelForegroundColor: Self.appearance.colors.textPrimaryShade1.color,
                                         rightLabelForegroundColor: Self.appearance.colors.textPrimaryShade1.color)
                      HorizontalTextView(leftLabel:L10n.rrmTotalCost,
                                         value: $model.totalCost,
                                         rightLabel: srcCurrency.iso3Code)
                    }
                  }
                }
                #if !targetEnvironment(simulator)
                NavigationLink(destination: RecipientIdentityVerifier(countries: model.countriesList, apiSession: model.apiSession as! ApiSession), isActive: $goToIDology) { EmptyView() }
                #endif
              }
            }
          }
        }
        if let quote = model.quote {
          Text(L10n.rrmSlaDisclaimerText(quote.deliverySLA.name))
            .font(infoFont)
            .foregroundColor(infoColor)
            .padding(.bottom, 4)
            .padding(.horizontal, 16)
        }
        if !model.transferTypes.isEmpty {
          if model.isLoading {
            Button {} label: {
              ActivityIndicator(animated: true)
            }
            .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
            .padding(.vertical, 10)
          } else {
            if let vm = model.recipientDetailsViewModel {
              if isCountrySelected {
                let transferReviewVM = self.setupRecipientSelected(vm: model.recipientDetailsViewModel!)
                NavigationLink(destination: TransferReviewView(model: transferReviewVM, rootIsActive: self.$rootIsActive, transferIsActive: self.$transferDetailsIsActive),
                               isActive: $transferDetailsIsActive) {
                  EmptyView()
                }.isDetailLink(false)
              } else {
                NavigationLink(destination: RecipientDetailsView(model: vm, rootIsActive: self.$rootIsActive, transferIsActive: self.$transferDetailsIsActive),
                               isActive: $transferDetailsIsActive) {
                  EmptyView()
                }.isDetailLink(false)
              }
              Button(action: validate) { Text(L10n.rrmContinueButton) }
                .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
                .padding(.vertical, 10)
            } else {
              Button(action: validate) { Text(L10n.rrmContinueButton) }
                .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
                .padding(.vertical, 10)
            }
          }
        }
      }
      .frame(maxWidth: .infinity,
             minHeight: geometry.size.height,
             alignment: .top)
      .onAppear(perform: {
        model.load()
        if isCountrySelected {
          model.getRecipientData(recipientId: (recipientData?.recipientId)!)
        }
      })
      .alertApiFailure($model.failure) {
        model.retry()
      }
      .overlay(model.isLoadingDstCounties ? LoadingStateView() : nil)
      .background(backgroundPageColor)
    }
    .navigationBarTitle(Text(L10n.rrmTransferDetails), displayMode: .inline)
    .navigationBarItems(leading:Button(action: {
      model.restoreData { _ in
        self.presentationMode.wrappedValue.dismiss()
      }
    }) { Text(L10n.rrmRecipientsListTitle) }
                        .buttonStyle(CallforactionButtonStyle(context: .borderless, disabled: false))
                        .padding(.leading, -50)
    )
    .onDisappear(perform:  {
      let featureFlag = UserDefaults.standard.bool(forKey: "IDologySDK")
      let kyc = UserDefaults.standard.string(forKey: "kycStatus")
      if featureFlag {
        if !transferDetailsIsActive && kyc != "ID_REQUIRED" {
          model.restoreData { _ in }
        }
      }else{
        if !transferDetailsIsActive {
          model.restoreData { _ in }
        }
      }
    })
    .background(backgroundPageColor)
  }
  
  private func launchSDK() {
    #if !targetEnvironment(simulator)
    let user = "brightwell.sdk"
    let password = "ReadyRemit9876!"
    
    let tokenService = IDologyTokenService()
    tokenService.getToken(user, password) { (token,error) in
      self.sfpc.initialize(token) { ready in
        if ready {
          self.goToIDology = true
        }else{
          print("Could not initialize")
        }
      }
    }
    #endif
  }
  
  func validate() {
    let featureFlag = UserDefaults.standard.bool(forKey: "IDologySDK")
    if featureFlag {
      guard let kyc = UserDefaults.standard.string(forKey: "kycStatus") else {
        goToNextScreen()
        return
      }
      if kyc == "ID_REQUIRED"{
        launchSDK()
        }else{
          goToNextScreen()
        }
    }else{
      goToNextScreen()
    }
  }
  
  func goToNextScreen(){
    UserDefaults.standard.set("", forKey: "countrySelectedForDropdown")
    invalidFields = model.validate()
    if invalidFields.isEmpty && !model.isLoading {
      transferDetailsIsActive = true
    }
  }
  
  func setupRecipientSelected(vm: RecipientDetailsViewModel) -> TransferReviewViewModel {
    var arr = [AdditionalField]()
    let _ = recipientAccounts!.fields.forEach { j in
      arr.append(AdditionalField(type: j.type!, id: j.id!, name: j.name ?? "", value: DynamicFieldValue(value: j.value!)))
    }
    var recArr = [AdditionalField]()
    let _ = model.recipientData?.fields.forEach { j in
      recArr.append(AdditionalField(type: j.type, id: j.id, name: j.name ?? "", value: j.value))
    }
    
    let createRecipient = CreateRecipient(
      recipientId: (recipientData?.recipientId)!,
      senderId: (recipientData?.senderId)!,
      recipientType: "PERSON",
      firstName: (recipientData?.firstName)!,
      lastName: (recipientData?.lastName)!,
      fields: recArr)
     
    let recipientAccount = RecipientAccount(
      recipientAccountId: recipientAccounts?.recipientAccountId ?? "",
      accountNumber: (recipientAccounts?.accountNumber)!,
      fields: arr)
    
    let transferReviewVM: TransferReviewViewModel = TransferReviewViewModel(apiSession: vm.apiSession, quote: vm.quote, dstCountry: vm.dstCountry, recipient: createRecipient, bankDetails: recipientAccount, dstCurrency: vm.dstCurrency)
    return transferReviewVM
  }
  
  var pageTitleFont: Font {
    let spec = Self.appearance.dropdownListStyle.titleFontSpec ?? Self.appearance.fonts.headline
    return .font(spec: spec, style: .headline)
  }
  var backgroundPageColor: Color {
    Self.appearance.colors.backgroundColorPrimary.color
  }
  var primaryShadeColor: Color {
    Self.appearance.colors.primaryShade1.color
  }
  var infoFont: Font {
    let spec = Self.appearance.inputStyle.infoFontSpec ?? Self.appearance.fonts.footnote
    return .font(spec: spec, style: .footnote)
  }
  var infoColor: Color {
    Self.appearance.inputStyle.infoFontColor?.color ??
    Self.appearance.colors.textPrimaryShade4.color
  }
}


#if DEBUG

struct TransferDetailView_Previews: PreviewProvider {
  
  static let token = OAuthToken(tokenType: "token",
                                           accessToken: "access",
                                           expiresInSeconds: 600)
  static let tokenStore = AuthTokenStore(authToken: token)
  static let session = ApiSession(environment: ApiEnvironment.mock,
                                  authTokenStore: tokenStore)
  static let model = TransferDetailsViewModel(apiSession: session)
  
  static var previews: some View {
    Group {
      TransferDetailsView(model: model, isCountrySelected: false, Binding.constant(true))
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
      TransferDetailsView(model: model, isCountrySelected: false, Binding.constant(true))
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
  }
}

#endif
