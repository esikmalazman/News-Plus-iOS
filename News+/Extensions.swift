//
//  Extensions.swift
//  News+
//
//  Created by Ikmal Azman on 19/07/2021.
//

import UIKit


// Allow to download image from URL Asyncronously
extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

// Allow to display underline border in segments
extension UISegmentedControl{
    
    func removeBorder(){
        tintColor = UIColor.clear
        backgroundColor = UIColor.clear
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], for: .selected)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.clear], for: .normal)
    }
    
    func setupSegment(){
        self.removeBorder()
        let segmentUnderlineWidth : CGFloat = bounds.width
        let segmentUnderlineHeight : CGFloat = 2.0
        let underlineXposition = bounds.minX
        let underlineYposition = bounds.size.height - 1.0
        let segmentUnderlineFrame = CGRect(x: underlineXposition, y: underlineYposition, width: segmentUnderlineWidth, height: segmentUnderlineHeight)
        let segmentUnderline = UIView(frame: segmentUnderlineFrame)
        segmentUnderline.backgroundColor = UIColor.clear
        
        addSubview(segmentUnderline)
        self.addUnderlineForSelectedSegment()
        
    }
    
    func addUnderlineForSelectedSegment(){
        
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(named: "SourcesColor")
        underline.tag = 1
        self.addSubview(underline)
    }
    
    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        underline.frame.origin.x = underlineFinalXPosition
        
    }
    
    
}
