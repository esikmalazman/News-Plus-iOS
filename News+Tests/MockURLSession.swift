@testable import News_
import XCTest

/// URLSession spy call
final class MockURLSession: NetworkManagerContract {
 
    var dataTaskCallCount = 0
    var dataTaskArguement = [URLRequest]()
    var dataTaskArguementCompletionHandler = [(Data?, URLResponse?, Error?)->Void]()
    
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
        dataTaskArguementCompletionHandler.append(completionHandler)
        
        return DummyURLSessionDataTask()
    }
    
    func verifyDataTask(with urlRequest : URLRequest, file : StaticString = #file, line : UInt = #line) {
        XCTAssertEqual(dataTaskCallCount, 1, file: file, line: line)
        XCTAssertEqual(dataTaskArguement.first, urlRequest, file: file, line: line)
    }
}

/// Subclass of URLSessionDataTask class to ovveride the implementation
///
private class DummyURLSessionDataTask : URLSessionDataTask {
    override func resume() {
        /// Ovveride default implementation
    }
}


struct TestError : LocalizedError {
    let message : String

    var errorDescription: String? {message}
    
}
