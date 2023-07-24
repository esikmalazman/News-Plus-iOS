//
//  HttpClient.swift
//  News+
//
//  Created by Ikmal Azman on 24/07/2023.
//

import Foundation

final class HttpClient {
    
    let session : URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData<T : Decodable>(object:T.Type, for request : URLRequest) async -> Result<T, NError>{
        return await withCheckedContinuation{ continuation in
            fetchGenericData(object, request: request) { result in
                continuation.resume(returning: result)
            }
        }
    }
}

extension HttpClient {
    private func parseData<T:Decodable>(object : T.Type, data: Data, completion : @escaping ((Result<T,NError>)-> Void)) {
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            completion(.success(object))
            
        } catch {
            completion(.failure(.unableToDecode))
            debugPrint("Error to decode : \(error.localizedDescription)")
        }
    }
    
    private func fetchGenericData <T : Decodable> (_ object : T.Type, request : URLRequest,
                                                   completion : @escaping ((Result<T,NError>)-> Void)) {
        debugPrint(request.url as Any)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let _ = error  {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.invalidData))
                return
            }
            
            self.parseData(object: object, data: safeData, completion: completion)
        }
        
        task.resume()
    }
}
