//
//  AppDelegate.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/23/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder {
    let mainAssembler = MainAssembler()
    var window: UIWindow?
    
    override init() {
        super.init()
    }
}

extension AppDelegate :UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupWindow()
        let statusBar =  UIView()
        
        statusBar.frame = UIApplication.shared.statusBarFrame
        
        statusBar.backgroundColor = .white
        
        UIApplication.shared.keyWindow?.addSubview(statusBar)
        return true
    }
    
    func setupWindow(){
        let window  = UIWindow(frame: UIScreen.main.bounds)
        let homeRouter = mainAssembler.resolver.resolve(HomeNavigationDefault.self)
        homeRouter?.deliveryList()
        
        window.backgroundColor = .black
        window.rootViewController = homeRouter?.navigationController
        window.makeKeyAndVisible()
        self.window = window
        
    }
}
