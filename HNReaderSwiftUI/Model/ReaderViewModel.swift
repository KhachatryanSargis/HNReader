//
//  ReaderViewModel.swift
//  HNReaderSwiftUI
//
//  Created by Sargis Khachatryan on 07.09.24.
//

import Foundation
import HNReaderAPI
import Combine

class ReaderViewModel: ObservableObject {
    @Published var allStories = [Story]()
    @Published var error: API.Error? = nil
    @Published var filter = [String]()
    
    private var sunscriptions = Set<AnyCancellable>()
    private let api = API()
    
    var stories: [Story] {
        guard !filter.isEmpty else {
            return allStories
        }
        return allStories
            .filter { story -> Bool in
                return filter.reduce(false) { isMatch, keyword -> Bool in
                    return isMatch || story.title.lowercased().contains(keyword)
                }
            }
    }
    
    func fetchStories() {
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
            .store(in: &sunscriptions)
    }
}
