//
//  NewsCollectionVC.swift
//  News+
//
//  Created by Ikmal Azman on 18/07/2021.
//

import UIKit
import SafariServices

final class NewsCollectionVC: UIViewController {
    
    let iso8601Formatter = ISO8601DateFormatter()
    
    var newsData = [News]()
    var pageNumber = 1
    var fetchMoreNews = false
    var networkManager = NetworkManager.shared
    
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
    
    func getNews(topic : String = "World") {
        
        networkManager.fetchGenericData(topic: topic) { (result : Result<NewsResponse, NError>) in
            switch result {
            case .success(let news):
                self.updateUI(with: news.articles)
            case .failure(let failure):
                print(failure.rawValue)
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
        
        cell.configureCell(data: listOfNews)

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
extension NewsCollectionVC {}
