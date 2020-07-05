//
//  News_Navigation.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/30/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import Swinject
import Domain
import RepositroyPlatform
import LocalPlatform

protocol NewsFeedNavigation {
    func detail(_ news: NewsModel)
    func list()
}

class DefaultNewsFeedNavigation: NewsFeedNavigation {
    
    let services: NewsXMLUsecase
    let favoriteUsecase: FavoriteUsecase
    let navigationController: UINavigationController
    
    init(services: NewsXMLUsecase, favoriteUsecase: FavoriteUsecase, navigation: UINavigationController ) {
        
        self.services = services
        self.favoriteUsecase = favoriteUsecase
        self.navigationController = navigation
    }
    
    func detail(_ news: NewsModel) {
        let detailNavigator = DefaultNewsDetailNavigation(navigation: self.navigationController)
        detailNavigator.newsDetail(news, self.favoriteUsecase)
    }

    func list() {
        let viewModel = NewsFeedVM(newsXMLUsecase: services, favoriteUsecases: favoriteUsecase, navigation: self)
        let home = NewsFeedVC(viewModel: viewModel)
        navigationController.tabBarItem = UITabBarItem(title: "News", image: #imageLiteral(resourceName: "icons8-rss-22"), tag: 0)
        navigationController.viewControllers = [home]
    }
}

//class NewsFeedNavigationAssembly: Assembly {
//    func assemble(container: Container) {
//        container.register(DefaultNewsFeedNavigation.self) { (resolver) in
//            let deliveryUsecaceImpl = resolver.resolve(RepositroyPlatform.DeliveryUsecaseImpl.self)!
//            let favoriteUsecaseImpl = resolver.resolve(FavoriteUsecaseImpl.self)!
//
//            let navigation = resolver.resolve(MainNavigationController.self)!
//            return DefaultNewsFeedNavigation(services: deliveryUsecaceImpl, favoriteUsecase: favoriteUsecaseImpl, navigation: navigation)
//        }.inObjectScope(.weak)
//    }
//}
