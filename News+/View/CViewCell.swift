//
//  CViewCell.swift
//  News+
//
//  Created by Ikmal Azman on 18/07/2021.
//

import UIKit

class CViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureForReuse()
    }
    
    func configureLayout(){
        
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    func configureForReuse(){
        
        newsImage.image = nil
        source.text = nil
        title.text = nil
        desc.text = nil
        date.text = nil
    }
}
