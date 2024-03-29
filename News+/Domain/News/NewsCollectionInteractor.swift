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
    var networkWorker = NewsNetworkWorker()
}

extension NewsCollectionInteractor : NewsCollectionBusinessLogic  {
    func loadNews(request: NewsCollectionModel.LoadNews.Request) {
        Task {
            let result = await networkWorker.fetchNews(for:request.topic.title)
            
            switch result {
            case .success(let data):
                let response = NewsCollectionModel.LoadNews.Response(newsCollectionData: data)
                self.presenter?.presentNewsCollection(response: response)
            case .failure(let failure):
                let response = NewsCollectionModel.LoadNews.Response(error: failure.rawValue)
                self.presenter?.presentNewsCollectionError(response:response)
                debugPrint("Fail to fetch news collection data : \(failure.localizedDescription)")
            }
        }
    }
}
