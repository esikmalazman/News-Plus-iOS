//
//  NewsModel.swift
//  News+
//
//  Created by Ikmal Azman on 15/07/2021.
//

import Foundation

struct NewsResponse : Decodable {
    
    let articles : [News]
}

struct News : Decodable {
    
    let title : String
    let description : String
    let url : URL
    let image : String
    let publishedAt : String
    let source : Source
}

struct Source : Decodable {
    
    let name : String
}
