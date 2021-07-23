//
//  NewsManager.swift
//  News+
//
//  Created by Ikmal Azman on 15/07/2021.
//

import UIKit

protocol NewsManagerDelegate {
    func didSendNewsData (_ newsManager: NewsManager, with news : [NewsModel])
}


struct NewsManager {
    
    var delegate : NewsManagerDelegate?
    
    let newsUrl = "https://gnews.io/api/v4/search?q="
    
    
    func fetchNews(topics : String = "World",page:Int = 1){
        
        // Access api key in secrets config
        if let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String{
            
            let urlString = "\(newsUrl)\(topics)&lang=en&page=\(page)&token=\(apiKey)"
            print(urlString)
            self.performRequest(with : urlString)
        }
    }
    
    
    func performRequest(with urlString : String){
        
        // 1. create URL object
        guard let url = URL(string: urlString) else {fatalError("There's problem to fetch data from this url")}
        
        // 2. create session, object to do networking
        let session = URLSession(configuration: .default)
        
        //3. give session a task
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil{
                print("Error in giving session a task \(String(describing: error?.localizedDescription))")
                
            }else {
                // determine if data is exist
                if let safeData = data {
                    
                    // Parse the data here
                    guard let news = parseJSON(safeData) else{ fatalError("Error parsing data from JSON")}
                    
                    DispatchQueue.main.async {
                        delegate?.didSendNewsData(self, with: news)
                        
                    }
                }
            }
        }
        //start the task
        task.resume()
    }
    
    func parseJSON(_ newsData : Data) -> [NewsModel]?{
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        var newsModel = [NewsModel]()
        
        do{
            
            let decodeData = try decoder.decode(NewsData.self, from: newsData)
            
            print(decodeData.articles.count)
            
            for article in decodeData.articles {
                
                let newsTitle = article.title
                let newsDesc = article.description
                let newsURL = article.url
                let urlToImage = article.image
                let publishedAt = article.publishedAt
                let newsSource = article.source.name
                
                let data = NewsModel(title: newsTitle, decription: newsDesc, url: newsURL, image: urlToImage, publishedAt: publishedAt, sourcesName: newsSource)
                
                newsModel.append(data)
            }
            return newsModel
            
        }catch {
            print("Error decode the data : \(error.localizedDescription)")
        }
        return newsModel
    }
}
