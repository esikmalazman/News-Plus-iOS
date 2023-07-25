//
//  NewsCollectionPresenter.swift
//  News+
//
//  Created by Ikmal Azman on 23/07/2023.
//

import Foundation

protocol NewsCollectionPresentationLogic {
    func presentNewsCollection(response : NewsCollectionModel.LoadNews.Response)
    func presentNewsCollectionError(response : NewsCollectionModel.LoadNews.Response)
}

final class NewsCollectionPresenter {
    var view : NewsCollectionDisplayLogic?
}

extension NewsCollectionPresenter : NewsCollectionPresentationLogic {
    func presentNewsCollection(response: NewsCollectionModel.LoadNews.Response) {
        let viewModel = NewsCollectionModel.LoadNews.ViewModel(newsCollection: response.newsCollectionData?.articles ?? [])
        view?.displayNewsCollection(viewModel:viewModel)
    }
    
    func presentNewsCollectionError(response: NewsCollectionModel.LoadNews.Response) {
        let viewModel = NewsCollectionModel.LoadNews.ViewModel(newsCollection: [], error: response.error)
        view?.displayErrorNewsCollection(viewModel: viewModel)
    }
}
