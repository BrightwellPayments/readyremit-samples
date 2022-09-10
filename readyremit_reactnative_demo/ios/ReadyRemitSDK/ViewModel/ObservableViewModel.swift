//
//  ObservableViewModel.swift
//  ReadyRemitSDK
//
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation
import Combine


class ObservableViewModel: ObservableObject {

    let didChange =  PassthroughSubject<Void, Never>()
    @Published var isLoading: Bool = false
    @Published var disabled: Bool = true
    @Published var enabled: Bool = false
}

class ObservableValue: ObservableObject {

    var didChange =  false
}
