//
//  NewsCollectionConfigurator.swift
//  News+
//
//  Created by Ikmal Azman on 23/07/2023.
//

import Foundation

extension NewsCollectionVC {
    func configureVC() {
        let view = self
        let interactor = NewsCollectionInteractor()
        let presenter = NewsCollectionPresenter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        newsDataStore.delegate = view
    }
}
