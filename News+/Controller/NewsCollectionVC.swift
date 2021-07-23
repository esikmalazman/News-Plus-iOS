//
//  NewsCollectionVC.swift
//  News+
//
//  Created by Ikmal Azman on 18/07/2021.
//

import UIKit
import SafariServices

class NewsCollectionVC: UIViewController {
    
    
    
    let iso8601Formatter = ISO8601DateFormatter()
    
    var newsManager = NewsManager()
    var newsResults = [NewsModel]()
    
    var dateFormatter : DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    var pageNumber = 1
    var fetchMoreNews = false
    
    
    @IBOutlet weak var newsSegments: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavBar()
    }
    
    func configureVC(){
        
        newsSegments.addUnderlineForSelectedSegment()
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        newsManager.delegate = self
        newsManager.fetchNews()
    }
    
    func configureNavBar(){
        // Set navbar to be transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        // Set navbar title attributes
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "NavBarColor") ?? .black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "NavBarColor") ?? .black]
    }
    
    
    
    @IBAction func newsDidSelect(_ sender: UISegmentedControl) {
        
        guard let segmentsTitle = sender.titleForSegment(at: newsSegments.selectedSegmentIndex) else {fatalError("There no segmented found") }
        
        newsSegments.changeUnderlinePosition()
        newsResults = []
        newsManager.fetchNews(topics: segmentsTitle)
        
    }
    
    
}

//MARK:- ColletionView DataSource

extension NewsCollectionVC : UICollectionViewDataSource {
    
    
    // Tell delegate how many cv need to show
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 2
        return newsResults.count
    }
    
    // Tell delegate content of cv
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let listOfNews = newsResults[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CViewCell
        
        cell.title.text = listOfNews.title
        cell.desc.text = listOfNews.decription
        cell.source.text = listOfNews.sourcesName
        
        // Convert damn ISO8601 to other format, https://developer.apple.com/forums/thread/660878
        if let date = iso8601Formatter.date(from: listOfNews.publishedAt){
            let formattedString = dateFormatter.string(from: date)
            cell.date.text = formattedString
        }
        
        cell.newsImage.downloaded(from: listOfNews.image)
        cell.newsImage.contentMode = .scaleToFill
        
        return cell
    }
    
}

//MARK:- CollectionView Delegate

extension NewsCollectionVC : UICollectionViewDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNews = newsResults[indexPath.row]
        // Provide VC to run url in app
        let SafariVC = SFSafariViewController(url: selectedNews.url)
        // Present the app
        present(SafariVC, animated: true, completion: nil)
        
    }
}

//MARK:- NewsManager Delegate

extension NewsCollectionVC : NewsManagerDelegate {
    
    func didSendNewsData(_ newsManager: NewsManager, with news: [NewsModel]) {
        
        DispatchQueue.main.async{
            
            self.newsResults.append(contentsOf: news)
            self.collectionView.reloadData()
            print("Current Page Number : \(self.pageNumber) | News Result :\(self.newsResults.count)")
            
        }
    }
}


//MARK:- Fetch more news methods

// TODO : Add pagination/infinite scroll in future
extension NewsCollectionVC {
    
    // Function to fetch more news
    func fetchOtherNews(){
        
        fetchMoreNews = true
        print("Begin Fetch More News")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            
            print("Page number : \(self.pageNumber) | newResults : \(self.newsResults.count)")
            self.fetchMoreNews = false
            self.newsManager.fetchNews(page: self.pageNumber)
        }
    }
    
    
    // Tell delegate when user start scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offSetY > contentHeight - scrollView.frame.height * 2 {
            
            if !fetchMoreNews{
                pageNumber += 1
                //fetchOtherNews()
                //collectionView.reloadData()
            }
        }
    }
}
