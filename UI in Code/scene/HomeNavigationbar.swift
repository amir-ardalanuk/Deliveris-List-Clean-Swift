//
//  HomeNavigation.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/23/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import Swinject
class MainNavigationController: UINavigationController {
 
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setup()
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    func setup() {
        self.navigationBar.tintColor = .black
        self.navigationBar.barTintColor = .white
    }
}

class CustomHomeNavigationBar: UINavigationBar {
    
    var title: String? {
        get {
            return label.text
        }
        set {
            self.label.text = newValue ?? "--"
        }
    }
    
    let label: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.addSubview(label)
        labelConstraint()
        self.backgroundColor = .white
    }
    
    private func labelConstraint() {
        let constraints = [
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

class MainNavigationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MainNavigationController.self) { (_) in
            return MainNavigationController()
        }
    }
    
}
