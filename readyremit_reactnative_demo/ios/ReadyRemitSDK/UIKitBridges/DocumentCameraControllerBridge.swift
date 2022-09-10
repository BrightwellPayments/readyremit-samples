//
//  DocumentCameraControllerBridge.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 18/08/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//

import SwiftUI
#if !targetEnvironment(simulator)
import UIKit
import ScanForensicsPlus
import AcuantCommon
import AcuantCamera
import AcuantFaceCapture
import AcuantImagePreparation
import AcuantPassiveLiveness

struct DocumentCameraControllerBridge: UIViewControllerRepresentable {
  typealias UIViewControllerType = DocumentCameraController
  
  @Environment(\.presentationMode) var presentationMode
  @Binding var currentImage: UIImage?
  @Binding var docSidePassport: DocSide?
  @Binding var acuantImage: AcuantImage?
  @Binding var frontDocument: String?
  @Binding var backDocument: String?
  @Binding var idTypeDocument: DocType?
  
  class Coordinator: CameraCaptureDelegate {
    var parent: DocumentCameraControllerBridge
    
    init(_ parent: DocumentCameraControllerBridge) {
      self.parent = parent
    }
    
    func setCapturedImage(image: AcuantCommon.Image, barcodeString: String?) {
      
      if image.image != nil {
        ImagePreparation.evaluateImage(data: CroppingData.newInstance(image: image)) { result, error in
          DispatchQueue.main.async {
            if result != nil {
              if image.isPassport{
                self.parent.docSidePassport = .back
                self.parent.idTypeDocument = .PASSPORT
              }
              self.parent.idTypeDocument = .DRIVERS_LICENSE
              let imageStr = result!.image.base64
              
              switch self.parent.docSidePassport {
              case .front:
                self.parent.frontDocument = imageStr
              case .back:
                self.parent.backDocument = imageStr
              default:
                print("Done!")
              }
              
              self.parent.acuantImage = result!
              self.parent.currentImage = result!.image

              self.parent.presentationMode.wrappedValue.dismiss()
            }else {
              print("ERROR::::: \(String(describing: error?.errorDescription))")
            }
          }
        }
      }
    }
  }
  
  func makeUIViewController(context: Context) -> DocumentCameraController {
    let options = CameraOptions(
      digitsToShow: 2,
      autoCapture: true,
      hideNavigationBar: true,
      colorHold: UIColor.red.cgColor,
      colorCapturing: UIColor.red.cgColor,
      showBackButton: false)
    let documentCameraController = DocumentCameraController.getCameraController(delegate: context.coordinator, cameraOptions: options)
    return documentCameraController
  }
  
  func updateUIViewController(_ uiViewController: DocumentCameraController, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}
#else
struct DocumentCameraControllerBridge: View {
    var body: some View {
        Text("")
    }
}
#endif
