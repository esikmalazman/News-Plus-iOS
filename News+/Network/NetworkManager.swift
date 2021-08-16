//
//  NetworkManager.swift
//  News+
//
//  Created by Ikmal Azman on 15/08/2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let urlSession = URLSession(configuration: .default)
    private let baseNewsUrl = "https://gnews.io/api/v4/search?q="
    
    // Result <Value,Error> type, remove ambiguity of the optionals, value that represent either success/failure include associate value in each case
    // @escaping, closure that live outside its function (completion handler), allow to execute other method when the request complete, added to ARC while wait for response
    func getNews(for topic : String, at page : Int, completed : @escaping (Result<[News],NError>) -> Void ) {
        
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { fatalError("No API_KEY found")}
        
        let endPoint = baseNewsUrl + "\(topic)&lang=en&page=\(page)&token=\(apiKey)"
        print(endPoint)
        
        var newsCollection : [News] = []
        
        guard let url = URL(string: endPoint) else {
            // Specifically specify failure case for the result type
            completed(.failure(.invalidTopic))
            return
        }
        
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                //print(error?.localizedDescription)
                //completed(error?.localizedDescription)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let safeData = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                // Decode the array of news response
                let newsDecode = try decoder.decode(NewsResponse.self, from: safeData)
                
                // Looping each article in list of newsResponse
                for article in newsDecode.articles {
                    newsCollection.append(article)
                }
                print("News : \(newsDecode)")
                // Specifically specify success case for the result type
                completed(.success(newsCollection))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}



