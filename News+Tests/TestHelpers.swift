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
