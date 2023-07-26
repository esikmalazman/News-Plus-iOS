//
//  NetworkManager.swift
//  News+
//
//  Created by Ikmal Azman on 15/08/2021.
//

import Foundation

enum Endpoint {
    case search(topic : String)
    
    var url : String {
        switch self {
        case .search(let topic):
            return "https://gnews.io/api/v4/search?q=\(topic)&lang=en&country=sg&apikey="
        }
    }
}

final class NewsNetworkWorker {
    
    let client :HttpClient
    
    init(client: HttpClient = HttpClient()) {
        self.client = client
    }
    
    private var apiKey : String {
        get {
            guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { fatalError("No API_KEY found")}
            return apiKey
        }
    }
    
    func fetchNews(for topic : String) async -> Result<NewsResponse, NError> {
        let endPoint = "\(Endpoint.search(topic: topic).url)\(apiKey)"
        
        guard let url = URL(string: endPoint) else {
            return .failure(.invalidURL)
        }
        
        let request = URLRequest(url: url)
        
        let result = await client.fetchData(object: NewsResponse.self, for: request)
        return result
    }
}
