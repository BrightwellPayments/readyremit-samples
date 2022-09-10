//
//  RemoteImage.swift
//  ReadyRemitSDK
//
//  Created by Mohan Reddy on 23/09/21.
//

import Foundation
import SwiftUI

struct RemoteImage: View {
   
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading

        init(url: String) {
            guard let parsedURL = URL(string: url) else {
                return
            }

            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }

                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }

    @ObservedObject private var loader: Loader
    var loading: Image
    var failure: Image

    var body: some View {
        selectImage()
            .resizable()
            .cornerRadius(2.0)
            .shadow(color: .gray, radius: 1.0, x: 0, y: 0)
            .aspectRatio(contentMode: .fit)
    }

  init(url: String,
       loading: Image = Image(systemName: "photo"),
       failure: Image = Image(systemName: "multiply.circle")) {
    _loader = ObservedObject(wrappedValue: Loader(url: url))
    self.loading = loading
    self.failure = failure
  }

    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}


struct RemoteImage_Previews: PreviewProvider {

  static var previews: some View {
    RemoteImage(url: "")
      .previewLayout(.sizeThatFits)
  }
}
