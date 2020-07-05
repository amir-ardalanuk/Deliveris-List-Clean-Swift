//
//  NewsSaved_Navigation.swift
//  UI in Code
//
//  Created by Amir Ardalan on 7/5/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import Domain

protocol NewsSavedNavigation {
    func newsSaved( _ favoriteUsecase: FavoriteUsecase)
}

class DefaultNewsSavedNavigation: NewsSavedNavigation {
   

    let navigation: UINavigationController!
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func newsSaved(_ favoriteUsecase: FavoriteUsecase) {
           let viewModel = NewsDetailVM(newsModel: model, favoriteUsecases: favoriteUsecase, navigation: self)
                 let detail = NewsDetailVC(viewModel: viewModel)
                 detail.hidesBottomBarWhenPushed = true
                 self.navigation.pushViewController(detail, animated: true)
       }
       
    
}
