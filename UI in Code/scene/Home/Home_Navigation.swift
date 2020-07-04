//
//  HomeNavigation.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/23/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import Swinject
import Domain
import RepositroyPlatform
import LocalPlatform

protocol HomeNavigation {
    func detail(_ delivery: DeliveryEntity)
    func deliveryList()
}

class HomeNavigationDefault: HomeNavigation {
    
    let services: DeliveryUsecases
    let favoriteUsecase: FavoriteUsecase
    let navigationController: UINavigationController
    
    init(services: DeliveryUsecases, favoriteUsecase: FavoriteUsecase, navigation: UINavigationController) {
        
        self.services = services
        self.favoriteUsecase = favoriteUsecase
        self.navigationController = navigation
    }
    
    func detail(_ delivery: DeliveryEntity) {
        let detailNavigator = DefaultDeliveryDetailNavigation(navigation: self.navigationController)
        detailNavigator.deliveryDetail(delivery, favoriteUsecase)
    }
    
    func deliveryList() {
        let viewModel = HomeViewModel(deliveryServices: services, favoriteUsecases: favoriteUsecase, navigation: self)
        let home = HomeViewController(viewModel: viewModel)
        navigationController.viewControllers = [home]
       // return navigationController
    }
}

class HomeRouterAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeNavigationDefault.self) { (resolver) in
            let deliveryUsecaceImpl = resolver.resolve(RepositroyPlatform.DeliveryUsecaseImpl.self)!
            let favoriteUsecaseImpl = resolver.resolve(FavoriteUsecaseImpl.self)!
            
            let navigation = resolver.resolve(MainNavigationController.self)!
            return HomeNavigationDefault(services: deliveryUsecaceImpl, favoriteUsecase: favoriteUsecaseImpl, navigation: navigation)
        }.inObjectScope(.weak)
    }
}
