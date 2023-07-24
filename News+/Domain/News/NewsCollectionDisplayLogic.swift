//
//  NewsCollectionDisplayLogic.swift
//  News+
//
//  Created by Ikmal Azman on 23/07/2023.
//

import Foundation

protocol NewsCollectionDisplayLogic {
    func displayNewsCollection(viewModel:NewsCollectionModel.LoadNews.ViewModel)
}

extension NewsCollectionVC : NewsCollectionDisplayLogic {
    func displayNewsCollection(viewModel: NewsCollectionModel.LoadNews.ViewModel) {
        DispatchQueue.main.async {
            self.newsDataStore.news.append(contentsOf: viewModel.newsCollection)
        }
    }
}
