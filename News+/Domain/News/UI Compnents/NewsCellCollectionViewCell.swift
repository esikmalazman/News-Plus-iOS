//
//  NewsCellCollectionViewCell.swift
//  News+
//
//  Created by Ikmal Azman on 26/07/2023.
//

import UIKit

final class NewsCellCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    static let identifier : String = "NewsCellCollectionViewCell"
    
    static func nib()-> UINib {
        return UINib(nibName: NewsCellCollectionViewCell.identifier, bundle: .main)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Variables
    private var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private let iso8601Formatter = ISO8601DateFormatter()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureForReuse()
    }
    
    func configureCell(data : News) {
        title.text = data.title
        source.text = data.source.name
        
        newsImage.downloadImage(fromURLString:data.image)
        newsImage.layer.cornerRadius = 5
        
        // Convert damn ISO8601 to other format, https://developer.apple.com/forums/thread/660878
        let isoDate = iso8601Formatter.date(from: data.publishedAt)
        let formattedString = dateFormatter.string(from: isoDate ?? Date())
        date.text = formattedString
    }
    
}

//MARK: - Private Methods
extension NewsCellCollectionViewCell {
    private func configureForReuse(){
        newsImage.image = nil
        source.text = nil
        title.text = nil
        date.text = nil
    }
}
