//
//  NewsCollectionModel.swift
//  News+
//
//  Created by Ikmal Azman on 23/07/2023.
//

import Foundation

enum NewsCollectionModel {
    enum LoadNews {
        struct Request {
            var topic : Category
        }
        
        struct Response {
            var newsCollectionData : NewsResponse?
            var error : String?
        }
        
        struct ViewModel {
            var newsCollection : [News]
            var error : String?
        }
    }
}
