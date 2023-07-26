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

        let segmentTitle = sender.titleForSegment(
            at: newsSegments.selectedSegmentIndex) ?? ""
        
        let category = Category(rawValue: segmentTitle.lowercased()) ?? .world
        
        self.selectedNewsSection = category
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
    
    func displayNewsCollectionError(_ error: String) {
        showErrorAlert(error)
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
    
    func showErrorAlert(_ error: String) {
        let alert = UIAlertController(title: "Network Error", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        let refreshAction = UIAlertAction(title: "Refresh", style: .default) { [weak self] _ in
            self?.loadNews()
        }
        alert.addAction(okAction)
        alert.addAction(refreshAction)
        self.present(alert, animated: true)
    }
}
