@testable import News_
import XCTest

/// URLSession spy call
final class MockURLSession: NetworkManagerContract {
 
    var dataTaskCallCount = 0
    var dataTaskArguement = [URLRequest]()
    var apiKey : String {
        get {
            guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { fatalError("No API_KEY found")}
            return apiKey
        }
    }
    
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        dataTaskCallCount = dataTaskCallCount + 1
        dataTaskArguement.append(request)
        
        return DummyURLSessionDataTask()
    }
}


/// Subclass of URLSessionDataTask class to ovveride the implementation
///
private class DummyURLSessionDataTask : URLSessionDataTask {
    override func resume() {
        /// Ovveride default implementation
    }
}
