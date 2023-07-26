//
//  CViewCell.swift
//  News+
//
//  Created by Ikmal Azman on 18/07/2021.
//

import UIKit

final class CViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var date: UILabel!
    
    //MARK: - Variables
    private var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private let iso8601Formatter = ISO8601DateFormatter()
    static let identifier = "cell"
    
    //MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureForReuse()
    }
    
    func configureCell(data : News) {
        title.text = data.title
        desc.text = data.description
        source.text = data.source.name
        
        newsImage.downloadImage(fromURLString:data.image)
        newsImage.contentMode = .scaleAspectFill
        
        // Convert damn ISO8601 to other format, https://developer.apple.com/forums/thread/660878
        let isoDate = iso8601Formatter.date(from: data.publishedAt)
        let formattedString = dateFormatter.string(from: isoDate ?? Date())
        date.text = formattedString
    }
}

//MARK: - Private Methods
extension CViewCell {
    
    private func configureLayout(){
        
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.2)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    private func configureForReuse(){
        newsImage.image = nil
        source.text = nil
        title.text = nil
        desc.text = nil
        date.text = nil
    }
}
