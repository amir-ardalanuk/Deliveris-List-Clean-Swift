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
    var app: Application!
    
    override init() {
        super.init()
        app = Application()
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //setupWindow()
        app.setupInitailController()
        let statusBar =  UIView()
        
        statusBar.frame = UIApplication.shared.statusBarFrame
        
        statusBar.backgroundColor = .white
        
        UIApplication.shared.keyWindow?.addSubview(statusBar)
        return true
    }
    
}
