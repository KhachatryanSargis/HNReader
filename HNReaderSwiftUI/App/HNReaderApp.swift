//
//  HNReaderApp.swift
//  HNReader
//
//  Created by Sargis Khachatryan on 06.09.24.
//

import SwiftUI

@main
struct HNReaderApp: App {
    let viewModel = ReaderViewModel()
    
    var body: some Scene {
        WindowGroup {
            ReaderView(model: viewModel)
        }
    }
}
