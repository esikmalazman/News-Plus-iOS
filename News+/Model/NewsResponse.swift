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

struct News : Decodable, Equatable {
    let title : String
    let description : String
    let url : String
    let image : String
    let publishedAt : String
    let source : Source
}

struct Source : Decodable, Equatable {
    let name : String
}
