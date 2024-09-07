//
//  ReaderViewModel.swift
//  HNReaderSwiftUI
//
//  Created by Sargis Khachatryan on 07.09.24.
//

import Foundation
import HNReaderAPI

class ReaderViewModel {
    private let api = API()
    private var allStories = [Story]()
    
    var filter = [String]()
    
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
    
    var error: API.Error? = nil
}
