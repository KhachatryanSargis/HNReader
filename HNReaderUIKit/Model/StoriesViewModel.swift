//
//  StoriesViewModel.swift
//  HNReaderUIKit
//
//  Created by Sargis Khachatryan on 07.09.24.
//

import Foundation
import HNReaderAPI
import Combine

class StoriesViewModel: ObservableObject {
    @Published var allStories = [Story]()
    @Published var error: API.Error? = nil
    
    private let api = API()
    private var subscriptions = Set<AnyCancellable>()
    
    init() { fetchStories() }
    
    private func fetchStories() {
        api
            .stories()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { stories in
                self.allStories = stories
                self.error = nil
            }
            .store(in: &subscriptions)
    }
}
