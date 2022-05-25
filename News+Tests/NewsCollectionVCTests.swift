@testable import News_
import XCTest

final class NewsCollectionVCTests: XCTestCase {
    
    var sut : NewsCollectionVC!
    var mockURLsession : MockURLSession!

    override func setUp() {
        super.setUp()
        let sb  = UIStoryboard(name: "Main", bundle: nil)
        sut = sb.instantiateViewController(identifier: "\(NewsCollectionVC.self)")
        
        mockURLsession = MockURLSession()
        sut.networkManager.urlSession = mockURLsession
        
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        mockURLsession = nil
        super.tearDown()
    }
    
    func test_loadViewController_shouldMakeDataTaskCalledOnce() {
        XCTAssertEqual(mockURLsession.dataTaskCallCount, 1)
        let request = URLRequest(url: URL(string: "https://gnews.io/api/v4/search?q=World&lang=en&token=\(mockURLsession.apiKey)")!)
        XCTAssertEqual(mockURLsession.dataTaskArguement.first, request)
    }
}
