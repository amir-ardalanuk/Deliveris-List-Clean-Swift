//
//  Application.swift
//  UI in Code
//
//  Created by Amir Ardalan on 7/1/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import RepositroyPlatform
import LocalPlatform

class Application {
    let mainAssembler = MainAssembler()
    var window: UIWindow?
    
    init() {
        
    }
    
    func setupInitailController() {
        let tabbar = UITabBarController()
        tabbar.viewControllers = [newsNavigation()]
        self.setupWindow(initailController: tabbar)
        
    }
    
    private func newsNavigation() -> UINavigationController {
        let navigationController = MainNavigationController()
        print(mainAssembler.resolver.self)
        let newsXMLServices = mainAssembler.resolver.resolve(NewsXMLUsecaseImpl.self)!
        let favServices = mainAssembler.resolver.resolve(FavoriteUsecaseImpl.self)!
        let news = DefaultNewsFeedNavigation(services: newsXMLServices,
                                             favoriteUsecase: favServices,
                                             navigation: navigationController)
        news.list()
        return navigationController
    }
    
    private func setupWindow(initailController initVC: UIViewController) {
           let window  = UIWindow(frame: UIScreen.main.bounds)
           
           //let homeRouter = mainAssembler.resolver.resolve(HomeNavigationDefault.self)
           //homeRouter?.deliveryList()
           
           window.backgroundColor = .black
           window.rootViewController = initVC
           window.makeKeyAndVisible()
           self.window = window
           
       }
}
