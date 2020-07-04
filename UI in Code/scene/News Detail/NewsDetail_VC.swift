//
//  NewsDetail_VC.swift
//  UI in Code
//
//  Created by Amir Ardalan on 7/1/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift

class NewsDetailVC: UIViewController {
    
    var webView: WKWebView!
    var viewModel: NewsDetailVM!
    let bag = DisposeBag()
    
    init(viewModel: NewsDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var favbutton: UIButton {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("", for: UIControl.State.normal)
        btn.setImage(#imageLiteral(resourceName: "icons8-love-96"), for: UIControl.State.normal)
        btn.backgroundColor = .white
        btn.tintColor = .gray
        //btn.radius(8)
        //btn.widthAnchor.constraint(equalToConstant: 35).isActive = true
        return btn
    }
}

//Lifecycle
extension NewsDetailVC {
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        addFavButtonToNavigation()
        databinding()
    }
}

//Contraint - Views
extension NewsDetailVC {
    func addFavButtonToNavigation() {
        let tabBarItem = UIBarButtonItem(customView: self.favbutton)
        self.navigationItem.rightBarButtonItem = tabBarItem
    }
}

//DataBinding
extension NewsDetailVC {
    func databinding() {
        let outPut = self.viewModel.transform(input: NewsDetailVM.Input(favTrigger: self.favbutton.rx.controlEvent(.touchUpInside).asDriver()))

        outPut.favColor.drive(favbutton.rx.tintColor).disposed(by: bag)
        outPut.link.drive(self.webView.rx.link).disposed(by: bag)
        
    }
}
extension NewsDetailVC: WKNavigationDelegate {
    
}

extension Reactive where Base: WKWebView {
    internal var link: Binder<URL> {
        return Binder(self.base, binding: { (view, data) in
            view.load(URLRequest(url: data))
            view.allowsBackForwardNavigationGestures = true
        })
    }
}
