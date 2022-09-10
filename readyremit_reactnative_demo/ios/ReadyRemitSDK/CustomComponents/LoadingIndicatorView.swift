//
//  LoadingIndicatorView.swift
//  ReadyRemitSDK
//
//  Created by Mohan Reddy on 24/09/21.
//

import SwiftUI

struct LoadingIndicatorView: View {
    
//    @Binding var isLoading: Bool
    @State private var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(ReadyRemitAppearance.shared.modalTransparentColor))
                .edgesIgnoringSafeArea(.all)
            GeometryReader { (geometry: GeometryProxy) in
                ForEach(0..<5) { index in
                    let scaleEffect = CGFloat(index) / 5
                    let width = geometry.size.width
                    let height = geometry.size.height
                    Group {
                        Circle()
                            .frame(width: width / 5, height: height / 5)
                            .scaleEffect(!self.isAnimating ? 1 - scaleEffect : 0.2 + scaleEffect)
                            .offset(y: width / 10 - height / 2)
                    }
                    .frame(width: width, height: height)
                    .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
                    .animation(Animation
                                .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
                                .repeatForever(autoreverses: false))
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 50, height: 50, alignment: .center)
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}

struct LoadingIndicatorView_Previews: PreviewProvider {
    
    @State static var isLoading: Bool = false
    
    static var previews: some View {
        LoadingIndicatorView()
    }
}
