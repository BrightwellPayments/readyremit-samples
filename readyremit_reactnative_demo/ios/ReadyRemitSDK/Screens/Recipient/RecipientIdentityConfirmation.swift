//
//  RecipientIdentityConfirmation.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 19/08/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//

import SwiftUI
#if !targetEnvironment(simulator)
import AcuantImagePreparation
import AcuantCommon
import ScanForensicsPlus
#endif
enum DocSide: Int {
  case front, back, none, end
}

enum DocType: String {
  case PASSPORT = "PASSPORT"
  case TIN = "TIN"
  case DRIVERS_LICENSE = "DRIVERS_LICENSE"
  case SSN = "SSN"
}

struct RecipientIdentityConfirmation: View, AppearanceConsumer {
  @Environment(\.presentationMode) var presentationMode
  @State var openCamera: Bool = false
  @State var takeSelfie: Bool = false
  @State var showAlert = false
  @State var alertTitle: String = ""
  @State var alertMessage: String = ""
  
  var imageView: UIImage? = nil
  @State var docSide: DocSide?
  @State var currentImage: UIImage?
  #if !targetEnvironment(simulator)
  @State var acuantImage: AcuantImage?
  #endif
  @State var frontImage: String?
  @State var backImage: String?
  @State var idType: DocType?
  @State var selfie: String?
  @State var dstCountryCode: String?
  @ObservedObject var model: IdentityConfirmationViewModel
  
    var body: some View {
      GeometryReader {_ in 
        VStack{
          if currentImage != nil {
            Image(uiImage: currentImage!)
              .resizable()
              .scaledToFit()
              .border(.blue, width: 1.0)
              .padding(.top, 100)
              .padding(.trailing, 15)
              .padding(.leading, 15)
            HStack {
              Button(L10n.rrmVerifyRetry){
                if docSide == .end {
                  takeSelfie = true
                }else{
                  openCamera = true
                }
              }
              .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
              .frame(width: 140, height: 35)
              .padding(.leading, 50)
              Spacer()
              if #available(iOS 14.0, *) {
                Button(action: acceptButton) { Text(L10n.rrmVerifyAccept) }
                  .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
                  .frame(width: 140, height: 35)
                  .padding(.trailing, 50)
                  .onChange(of: model.processIsDone) {_ in
                    if model.processIsDone {
                      model.processIsDone = false
                      presentationMode.wrappedValue.dismiss()
                    }
                  }
              } else {
                Button(action: acceptButton) { Text(L10n.rrmVerifyAccept) }
                  .buttonStyle(CallforactionButtonStyle(context: .primary, disabled: false))
                  .frame(width: 120, height: 35)
                  .padding(.trailing, 50)
              }
              
            }.padding(.top, 130)
          }
        }
        .onAppear {
          if currentImage == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
              alertTitle = L10n.rrmFrontPicTitle
              alertMessage = L10n.rrmFrontPicMessage
              showAlert = true
            }
          }
        }
        #if !targetEnvironment(simulator)
        .sheet(isPresented: $openCamera) {
          DocumentCameraControllerBridge(
            currentImage: $currentImage,
            docSidePassport: $docSide,
            acuantImage: $acuantImage,
            frontDocument: $frontImage,
            backDocument: $backImage,
            idTypeDocument: $idType
          )
        }
        .sheet(isPresented: $takeSelfie) {
          FaceCaptureControllerBridge(currentSelfie: $currentImage, base64Document: $selfie)
        }
        #endif
        .alert(isPresented: $showAlert) {
          Alert(
            title: Text(alertTitle),
            message: Text(alertMessage),
            dismissButton: .default(Text(L10n.rrmContinueButton), action: {
              savePicture()
            })
          )
        }
        .overlay(model.loading ? LoadingStateView() : nil)
        .alertApiFailure($model.failure) {
          model.failure = nil
          acceptButton()
        }
      }
      .background(backgroundPageColor)
    }
  
  func acceptButton() {
    #if !targetEnvironment(simulator)
    let good = ScanForensicsPlusController.isGoodImage(image: acuantImage ?? nil)
    print (" Is good image ? : \(good)")
    #endif
    
    switch(docSide) {
    case nil:
      alertTitle = L10n.rrmFrontPicMessage
      alertMessage = L10n.rrmFrontPicMessage
      showAlert = true
    case .front:
      alertTitle = L10n.rrmBackPicTitle
      alertMessage = L10n.rrmBackPicMessage
      showAlert = true
    case .back:
      alertTitle = L10n.rrmFacePicTitle
      alertMessage = L10n.rrmFacePicMessage
      showAlert = true
    case .end:
      showAlert = false
      sendData()
    case .some(.none):
      alertTitle = L10n.rrmFrontPicTitle
      alertMessage = L10n.rrmFrontPicMessage
      showAlert = true
    }
  }
  
  func sendData() {
    model.loading = true
    let ivm: [String:String] = [
      "CountryCode": dstCountryCode!,
      "Image": frontImage!,
      "BackImage": backImage!,
      "SelfieImage": selfie!,
      "IdType": idType!.rawValue
    ]
    model.sendIdentityData(identityValidationModel: ivm, senderId: "c96a7526-2412-4e8b-a6b0-cf70c3e55c72")
  }
  
  func savePicture() {
    openCamera = false
    showAlert = false
    takeSelfie = false
    switch(docSide) {
    case nil:
      docSide = .front
      openCamera = true
    case .front:
      docSide = .back
      openCamera = true
    case .back:
      docSide = .end
      takeSelfie = true
    case .end:
      UserDefaults.standard.removeObject(forKey: "kycStatus")
      presentationMode.wrappedValue.dismiss()
    case .some(.none):
      docSide = .front
      openCamera = true
    }
  }
  
  var backgroundPageColor: Color {
    Self.appearance.colors.backgroundColorPrimary.color
  }
}

#if DEBUG
struct RecipientIdentityConfirmation_Previews: PreviewProvider {
  static let token = OAuthToken(tokenType: "token",
                                           accessToken: "access",
                                           expiresInSeconds: 600)
  static let tokenStore = AuthTokenStore(authToken: token)
  static let session = ApiSession(environment: ApiEnvironment.mock,
                                  authTokenStore: tokenStore)
  static let model = IdentityConfirmationViewModel(apiSession: session)
  
    static var previews: some View {
      RecipientIdentityConfirmation(model: model)
    }
}
#endif
