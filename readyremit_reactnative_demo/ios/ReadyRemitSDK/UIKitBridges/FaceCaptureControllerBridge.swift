//
//  FaceCaptureControllerBridge.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 19/08/22.
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

struct FaceCaptureControllerBridge: UIViewControllerRepresentable {
  typealias UIViewControllerType = FaceCaptureController
  
  @Environment(\.presentationMode) var presentationMode
  @Binding var currentSelfie: UIImage?
  @Binding var base64Document: String?
  
  func makeUIViewController(context: Context) -> FaceCaptureController {
    let controller = FaceCaptureController()
    let options = AcuantFaceCapture.FaceCameraOptions(showOval: true)
    controller.options = options
    controller.callback = { image in
        if(image != nil){
          currentSelfie = image
          base64Document = image!.base64
          presentationMode.wrappedValue.dismiss()
        }
    }
    return controller
  }
  
  func updateUIViewController(_ uiViewController: FaceCaptureController, context: Context) {}
}
#else
struct FaceCaptureControllerBridge: View {
    var body: some View {
        Text("")
    }
}
#endif
