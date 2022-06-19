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
        let request = URLRequest(url: URL(string: "https://gnews.io/api/v4/search?q=World&lang=en&token=\(mockURLsession.apiKey)")!)
        mockURLsession.verifyDataTask(with: request)
    }
    
    func test_searchForWorldNews_withSuccessResponse_shouldReturnNewsData() {
        /// Networking operation perform in background thread, while test code working on main thread.
        /// Utlise expectation, allow us to syncronize thread between them
        let resultsExpectation = expectation(description: "handleResults called")
        
        sut.handleResults = { _ in resultsExpectation.fulfill()}
        /// Call closure from completion handler that we capture in mockURLSession
        /// Pass jsonData, 200 status code. no error
        mockURLsession.dataTaskArguementCompletionHandler
            .first?(jsonData(), response(statusCode: 200), nil)
        
        
        
        
        waitForExpectations(timeout: 0.01)
        let source = Source(name: "News+ Test")
        let news = News(title: "News+ Title",
                        description: "News+ Description",
                        url: "News+ URL",
                        image:"News+ Image",
                        publishedAt: "News+, \(Date())",
                        source: source)
        
        XCTAssertEqual(sut.newsData, [news])
    }
    
    /// Verify that data will not receive if it code skips the async closure (completion handler in dataTask)
    func test_searchForWorldNews_withSuccessResponseBeforeAsync_shouldNotReturnaAnyData() {
        mockURLsession.dataTaskArguementCompletionHandler
            .first?(jsonData(), response(statusCode: 200), nil)
        
        XCTAssertEqual(sut.newsData, [])
    }
    
    func test_searchForWorldNews_with404StatusCode_shouldNotReturnAnyData() {
        mockURLsession.dataTaskArguementCompletionHandler
            .first?(nil, response(statusCode: 404), TestError(message: "Ops, there's not network connection"))
        
        XCTAssertEqual(sut.newsData, [])
    }
    
    func test_searchForWorldNews_withMissingJSONData_shouldNotReturnAnyData() {
        mockURLsession.dataTaskArguementCompletionHandler
            .first?(missingJsonData(), response(statusCode: 500), nil)
        
        XCTAssertEqual(sut.newsData, [])
    }
    
    
//    func test_NewsCollectionViewDelegates_shouldBeConnected() {
//        XCTAssertNotNil(sut.collectionView.dataSource, "dataSource")
//        XCTAssertNotNil(sut.collectionView.delegate, "delegate")
//    }
//    
//    func test_numberOfItemsInSection_with3NewsDataInSection0_shouldHave3Row() {
//        sut.newsData = [
//            createNews(1),
//            createNews(2),
//            createNews(3)
//        ]
//        
//        XCTAssertEqual(numberOfItemsInSection(sut.collectionView), 3)
//    }
//    
//    func test_numberOfItemsInSection_withNoNewsDataInSection0_shouldNotHaveRow() {
//        sut.newsData = []
//        
//        XCTAssertEqual(numberOfItemsInSection(sut.collectionView), 0)
//    }
//    
//    func test_cellForItemAt_withRow0_shouldHavePropertiesNews1() {
//        sut.newsData = [createNews(1)]
//        
//        guard let cell = cellForItemAt(sut.collectionView, row: 0) as? CViewCell else {
//            XCTFail("Could not cast to \(CViewCell.self)")
//            return
//        }
//        
//        XCTAssertEqual(cell.title.text, "News 1")
//        XCTAssertEqual(cell.source.text, "Source 1")
//        XCTAssertEqual(cell.desc.text, "Description 1")
//    }
//    
//    func test_cellForItemAt_withRow1_shouldHavePropertiesNews2() {
//        sut.newsData = [
//        createNews(1),
//        createNews(2)
//        ]
//        
//        guard let cell = cellForItemAt(sut.collectionView, row: 1) as? CViewCell else {
//            XCTFail("Could not cast to \(CViewCell.self)")
//                    return
//        }
//        
//        XCTAssertEqual(cell.title.text, "News 2")
//        XCTAssertEqual(cell.source.text, "Source 2")
//        XCTAssertEqual(cell.desc.text, "Description 2")
//    }
    
    
    
    
    
    
}


//MARK: - Helpers
private extension NewsCollectionVCTests {
    func createNews(_ number : Int) -> News {
        return News(title: "News \(number)",
                    description: "Description \(number)",
                    url: "URL \(number)",
                    image: "Image \(number)",
                    publishedAt: "Published At \(number)",
                    source: Source(name: "Source \(number)"))
    }
    
    /// Helper method to supply json data if success
    func jsonData() -> Data {
        return """
{
   "articles":
    [
      {
         "title":"News+ Title",
         "description":"News+ Description",
         "content":"News+ Content",
         "url":"News+ URL",
         "image":"News+ Image",
         "publishedAt":"News+, \(Date())",
         "source":{
            "name":"News+ Test",
         }
      }
   ]
}
""".data(using: .utf8)!
    }
    
    func missingJsonData() -> Data {
        return """
{
   "articles":
    [
      {
         "description":"News+ Description",
         "content":"News+ Content",
         "url":"News+ URL",
         "image":"News+ Image",
         "publishedAt":"News+, \(Date())",
         "source":{
            "name":"News+ Test",
         }
      }
   ]
}
""".data(using: .utf8)!
    }
    
    /// Helper method to supply status code
    func response(statusCode : Int) -> HTTPURLResponse? {
        return HTTPURLResponse(url: URL(string: "http://DUMMY")!,
                               statusCode: statusCode,
                               httpVersion: nil,
                               headerFields: nil)
    }
}
