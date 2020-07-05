//
//  NewsDetail_Navigation.swift
//  UI in Code
//
//  Created by Amir Ardalan on 7/1/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import RepositroyPlatform
import Domain

protocol NewsDetailNavigation {
    func newsDetail(_ model: NewsModel, _ favoriteUsecase: FavoriteUsecase)
}

class DefaultNewsDetailNavigation: NewsDetailNavigation {

    let navigation: UINavigationController!
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func newsDetail(_ model: NewsModel, _ favoriteUsecase: FavoriteUsecase) {
        let viewModel = NewsDetailVM(newsModel: model, favoriteUsecases: favoriteUsecase, navigation: self)
        let detail = NewsDetailVC(viewModel: viewModel)
        detail.hidesBottomBarWhenPushed = true
        self.navigation.pushViewController(detail, animated: true)
    }
}
