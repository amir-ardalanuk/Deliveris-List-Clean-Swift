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
    let favTrigger = PublishSubject<Void>()
    
    init(viewModel: NewsDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var favbutton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("", for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(NewsDetailVC.onFavClick), for: .touchUpInside)
        
        return btn
    }()
}

//Lifecycle
extension NewsDetailVC {
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        self.title = "News Detail"
        
        addFavButtonToNavigation()
        databinding()
    }
  
    @objc func onFavClick() {
        favTrigger.onNext(())
    }
}

//Contraint - Views
extension NewsDetailVC {
    func addFavButtonToNavigation() {
        let tabBarItem = UIBarButtonItem(customView: self.favbutton)
        tabBarItem.tintColor = .red
        self.navigationItem.rightBarButtonItem = tabBarItem
    }
}

//DataBinding
extension NewsDetailVC {
    func databinding() {
       
        let outPut = self.viewModel.transform(input: NewsDetailVM.Input(favTrigger: self.favTrigger.asDriverOnErrorJustComplete()))
        outPut.link.drive(self.webView.rx.link).disposed(by: bag)
        outPut.favImage.observeOn(MainScheduler.instance).subscribe(onNext: { (image) in
            self.favbutton.setImage(image, for: .normal)
        }).disposed(by: bag)
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
