//
//  NewsCollectionDataStore.swift
//  News+
//
//  Created by Ikmal Azman on 23/07/2023.
//

import Foundation

protocol NewsCollectionDataStoreDelegate {
    func refreshNewsCollection()
    func displayNewsCollectionError(_ error: String)
}

final class NewsCollectionDataStore {
    var delegate : NewsCollectionDataStoreDelegate?
    
    var news : [News] = [] {
        didSet {
            delegate?.refreshNewsCollection()
        }
    }
    
    var error : String = "" {
        didSet {
            delegate?.displayNewsCollectionError(error)
        }
    }
}
