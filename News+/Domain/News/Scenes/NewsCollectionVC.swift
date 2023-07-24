//
//  NewsCollectionVC.swift
//  News+
//
//  Created by Ikmal Azman on 18/07/2021.
//

import UIKit

final class NewsCollectionVC: UIViewController {
    
    @IBOutlet weak var newsSegments: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var interactor : NewsCollectionBusinessLogic?
    var newsDataStore = NewsCollectionDataStore()
    var selectedNewsSection : Category = .world {
        didSet {
            loadNews()
        }
    }
    
    var pageNumber = 1
    var fetchMoreNews = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        loadNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
        setupCollectionView()
    }
    
    func loadNews() {
        let request = NewsCollectionModel.LoadNews.Request(topic: selectedNewsSection)
        interactor?.loadNews(request: request)
    }
}

// MARK:  Actions
extension NewsCollectionVC {
    @IBAction func newsDidSelect(_ sender: UISegmentedControl) {
        newsDataStore.news = []
        
        guard let segmentsTitle = sender.titleForSegment(
            at: newsSegments.selectedSegmentIndex) else {
            fatalError("There no segmented found")
        }
        
        guard let category = Category(rawValue: segmentsTitle.lowercased()) else {
            fatalError("Invalid category found")
        }
        
        self.selectedNewsSection = category
        loadNews()
    }
}

// MARK:  UICollectionViewDataSource
extension NewsCollectionVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return newsDataStore.news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let listOfNews = newsDataStore.news[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CViewCell.identifier, for: indexPath) as! CViewCell
        cell.configureCell(data: listOfNews)
        
        return cell
    }
}

// MARK:  UICollectionViewDelegate
extension NewsCollectionVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let newsURLString = newsDataStore.news[indexPath.row].url
        openSafariVC(newsURLString)
    }
}

// MARK:  NewsCollectionDataStoreDelegate
extension NewsCollectionVC : NewsCollectionDataStoreDelegate {
    func refreshNewsCollection() {
        collectionView.reloadData()
    }
}


private extension NewsCollectionVC {
    func configureNavBar() {
        // Set navbar to be transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        // Set navbar title attributes
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.navBarColor]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.navBarColor]
    }
    
    func setupCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
