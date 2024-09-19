//
//  Item.swift
//  SwiftTesting
//
//  Created by Dhanushkumar Kanagaraj on 19/09/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
