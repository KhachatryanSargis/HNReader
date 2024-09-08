//
//  Settings.swift
//  HNReaderSwiftUI
//
//  Created by Sargis Khachatryan on 07.09.24.
//

import Foundation
import Combine

fileprivate let keywordsFile = "filterKeywords"

final class Settings: ObservableObject {
    init() {
        if let storedKeywords: [FilterKeyword] = try? JSONFile.loadValue(named: keywordsFile) {
            self.keywords = storedKeywords
        }
    }
    
    @Published var keywords = [FilterKeyword]() {
        didSet {
            try? JSONFile.save(value: keywords, named: keywordsFile)
        }
    }
}
