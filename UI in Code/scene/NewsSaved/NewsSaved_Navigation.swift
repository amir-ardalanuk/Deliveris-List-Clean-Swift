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
    func newsSaved()
    func detail(_ news: NewsModel)
}

class DefaultNewsSavedNavigation: NewsSavedNavigation {
   
    let favoriteUsecase: FavoriteUsecase
    let navigationController: UINavigationController
    
    init( favoriteUsecase: FavoriteUsecase, navigation: UINavigationController ) {
        self.favoriteUsecase = favoriteUsecase
        self.navigationController = navigation
    }
    
    func newsSaved() {
        let viewModel = NewsSavedVM( favoriteUsecases: favoriteUsecase, navigation: self)
        let home = NewsSavedVC(viewModel: viewModel)
        navigationController.tabBarItem = UITabBarItem(title: "News Saved", image: #imageLiteral(resourceName: "icons8-love-96"), tag: 1)
        navigationController.viewControllers = [home]
    }
    
     func detail(_ news: NewsModel) {
          let detailNavigator = DefaultNewsDetailNavigation(navigation: self.navigationController)
          detailNavigator.newsDetail(news, self.favoriteUsecase)
      }

}
