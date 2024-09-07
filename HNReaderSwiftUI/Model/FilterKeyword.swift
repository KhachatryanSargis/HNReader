//
//  FilterKeyword.swift
//  HNReaderSwiftUI
//
//  Created by Sargis Khachatryan on 07.09.24.
//

import SwiftUI

struct FilterKeyword: Identifiable, Codable {
    var id: String { value }
    let value: String
}
