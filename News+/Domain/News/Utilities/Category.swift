//
//  Category.swift
//  News+
//
//  Created by Ikmal Azman on 23/07/2023.
//

import Foundation

enum Category : String {
    case world
    case sports
    case tech
    case business
    
    var title : String {
        switch self {
        case .world:
            return "world"
        case .sports:
            return "sports"
        case .tech:
            return "technology"
        case .business:
            return "business"
        }
    }
}
