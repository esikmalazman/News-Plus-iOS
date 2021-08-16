//
//  NewsModel.swift
//  News+
//
//  Created by Ikmal Azman on 15/07/2021.
//

import Foundation

struct NewsResponse : Codable {
    
    let articles : [News]
}

struct News : Codable {
    
    let title : String
    let description : String
    let url : URL
    let image : String
    let publishedAt : String
    let source : Source
}

struct Source : Codable {
    
    let name : String
}