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
    
    var newsData = [News]()
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
    
    private func configureVC() {
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        getNews()
    }
    
    private func configureNavBar() {
        // Set navbar to be transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        // Set navbar title attributes
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "NavBarColor") ?? .black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "NavBarColor") ?? .black]
    }
    
    func getNews(topic : String = "World", page : Int = 1) {
        
        NetworkManager.shared.getNews(for: topic, at: page) { [weak self] result in
            // you'll create a new local variable that will hold a strong reference to the outside weak self.
            guard let strongSelf = self else { return }
            
            switch result {
            
            case .success(let news):
                print("News in Success : \(news)")
                strongSelf.updateUI(with: news)
                
            case .failure(let error):
                // Debug custom error NError
                print(error.rawValue)
            }
        }
    }
    
    func updateUI(with news : [News]) {
        
        print("News Array : \(news.count)")
        DispatchQueue.main.async {
            self.newsData.append(contentsOf: news)
            self.collectionView.reloadData()
        }
        if news.isEmpty {
            print("There's no news available at the momment")
        }
    }
    
    
    @IBAction func newsDidSelect(_ sender: UISegmentedControl) {
        
        guard let segmentsTitle = sender.titleForSegment(at: newsSegments.selectedSegmentIndex) else {fatalError("There no segmented found") }
        
        newsData = []
        getNews(topic: segmentsTitle)
    }
}

//MARK:- ColletionView DataSource

extension NewsCollectionVC : UICollectionViewDataSource {
    
    // Tell delegate how many cv need to show
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 2
        return newsData.count
    }
    
    // Tell delegate content of cv
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let listOfNews = newsData[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CViewCell
        
        cell.title.text = listOfNews.title
        cell.desc.text = listOfNews.description
        cell.source.text = listOfNews.source.name
        cell.newsImage.downloaded(from: listOfNews.image)
        cell.newsImage.contentMode = .scaleToFill
        
        // Convert damn ISO8601 to other format, https://developer.apple.com/forums/thread/660878
        let date = iso8601Formatter.date(from: listOfNews.publishedAt)
        let formattedString = dateFormatter.string(from: date ?? Date())
        cell.date.text = formattedString
        
        return cell
    }
    
}

//MARK:- CollectionView Delegate

extension NewsCollectionVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedNews = newsData[indexPath.row]
        // Provide VC to run url in app
        let SafariVC = SFSafariViewController(url: selectedNews.url)
        // Present the news
        present(SafariVC, animated: true, completion: nil)
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
            print("Page number : \(self.pageNumber) | newResults : \(self.newsData.count)")
            self.fetchMoreNews = false
            //self.newsManager.fetchNews(page: self.pageNumber)
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
