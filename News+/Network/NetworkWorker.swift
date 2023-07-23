//
//  NetworkManager.swift
//  News+
//
//  Created by Ikmal Azman on 15/08/2021.
//

import Foundation

final class NetworkWorker {
    
    static let shared = NetworkWorker()
    /// Assign protocol as protocol, allow us to swap differente implementation for URLSession
    var urlSession : NetworkManagerContract = URLSession.shared
    
    private let baseNewsUrl = "https://gnews.io/api/v4/search?q="
    
    private var apiKey : String {
        get {
            guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { fatalError("No API_KEY found")}
            return apiKey
        }
    }
    
    func fetchGenericData <T : Decodable> (topic : String,
                                           completion : @escaping ((Result<T,NError>)-> Void)) {
        
        let endPoint = baseNewsUrl + "\(topic)&lang=en&token=\(apiKey)"
        
        guard let url = URL(string: endPoint) else {
            fatalError("Could not convert url string to type URL")
        }
        
        let urlRequest = URLRequest(url: url)
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let _ = error  {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.invalidData))
                return
            }
            print(url)
            
            do {
                let object = try JSONDecoder().decode(T.self, from: safeData)
                completion(.success(object))
                
            } catch {
                completion(.failure(.unableToDecode))
                print("Error to decode : \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
