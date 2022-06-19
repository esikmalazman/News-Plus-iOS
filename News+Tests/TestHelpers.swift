//
//  TestHelpers.swift
//  News+Tests
//
//  Created by Ikmal Azman on 19/06/2022.
//

import UIKit

//MARK: - CollectionView Test Helpers

func numberOfItemsInSection(_ collectionView: UICollectionView, section : Int = 0)-> Int? {
    return collectionView.dataSource?
        .collectionView(
            collectionView,
            numberOfItemsInSection: section)
}

func cellForItemAt(_ collectionView : UICollectionView,
                   row : Int,
                   section : Int = 0) -> UICollectionViewCell? {
    let indexPath  = IndexPath(row: row, section: section)
    let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath)
    return cell
}

func didSelectItemAt(_ collectionView : UICollectionView, row : Int, section : Int = 0 ) {
    let indexPath = IndexPath(row: row, section: section)
    collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
}

//MARK: - Utilities Test Helpers
func putViewInWindow(_ vc : UIViewController) {
    let window = UIWindow()
    window.addSubview(vc.view)
}
