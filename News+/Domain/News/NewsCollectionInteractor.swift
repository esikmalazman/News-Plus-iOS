//
//  NewsCollectionInteractor.swift
//  News+
//
//  Created by Ikmal Azman on 23/07/2023.
//

import Foundation

protocol NewsCollectionBusinessLogic {
    func loadNews(request: NewsCollectionModel.LoadNews.Request)
}

final class NewsCollectionInteractor {
    var presenter : NewsCollectionPresentationLogic?
    var networkManager = NetworkWorker.shared
}

extension NewsCollectionInteractor : NewsCollectionBusinessLogic  {
    func loadNews(request: NewsCollectionModel.LoadNews.Request) {
        networkManager.fetchGenericData(topic: request.topic.title) { (result : Result<NewsResponse, NError>) in
            switch result {
            case .success(let data):
                let response = NewsCollectionModel.LoadNews.Response(newsCollectionData: data)
                self.presenter?.presentNewsCollection(response: response)
            case .failure(let failure):
#warning("need to handle error soon")
                print("Fail to fetch news collection data : \(failure.localizedDescription)")
            }
        }
    }
}
