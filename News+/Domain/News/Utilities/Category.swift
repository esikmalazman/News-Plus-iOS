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
    case economy
    
    var title : String {
        switch self {
        case .world:
            return "World"
        case .sports:
            return "Sports"
        case .tech:
            return "Tech"
        case .economy:
            return "Economy"
        }
    }
}
