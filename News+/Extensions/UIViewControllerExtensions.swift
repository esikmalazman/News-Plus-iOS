//
//  UIViewControllerExtensions.swift
//  News+
//
//  Created by Ikmal Azman on 23/07/2023.
//

import UIKit
import SafariServices

extension UIViewController {
    func openSafariVC(_ url : String) {
        guard let url = URL(string: url) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
