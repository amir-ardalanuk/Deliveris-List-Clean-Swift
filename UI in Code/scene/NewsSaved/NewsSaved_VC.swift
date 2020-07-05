//
//  NewsSaved_VC.swift
//  UI in Code
//
//  Created by Amir Ardalan on 7/5/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import Domain
import RxCocoa
import RxSwift

class NewsSavedVC: UIViewController {
    
    let bag = DisposeBag()
    var viewModel: NewsSavedVM!
    let datasource = NewsDataSource()
    let getSavedList = PublishSubject<Void>()
    
    let loadingBar: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        return refreshControl
    }()
    
    var tableView: UITableView = {
        let tView = UITableView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        return tView
    }()
    
    init(viewModel: NewsSavedVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension NewsSavedVC {
    
    override func loadView() {
        super.loadView()
        title = "News Feed"
        tableViewConfig()
        makeTableViewConstaint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingBar.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.dataBinding()
        self.getSavedList.onNext(())
        self.view.backgroundColor = .white
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.getSavedList.onNext(())
    }
    
    func tableViewConfig() {
        tableView.delegate = datasource
        tableView.dataSource = datasource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(DeliveryCell.self, forCellReuseIdentifier: "DeliveryCell")
        tableView.addSubview(self.loadingBar)
        tableView.reloadData()
    }
    
}
//Data Binding
extension NewsSavedVC {
    
    func dataBinding() {
        let input = NewsSavedVM.Input(
            getList: getSavedList.asDriverOnErrorJustComplete(),
            selectedItem: tableView.rx.itemSelected.asDriver(),
            favoriteUpdated: datasource.favoriteSelected.asDriverOnErrorJustComplete())
       
        let output = self.viewModel.transform(input: input)
        output.list.drive(tableView.rx.newsDataSourceList).disposed(by: bag)
        output.loading.drive(self.loadingBar.rx.isRefreshing).disposed(by: bag)
        
    }
}

//Constraint
extension NewsSavedVC {
    
    func makeTableViewConstaint() {
        let mainStack = ViewMaker.makeStackView(axios: .vertical, distribution: .fill, aligment: .center, space: 8)
        self.view.addSubview(mainStack)
        
        mainStack.addArrangedSubview(tableView)
        
        mainStack.activateFillSafeAreaConstraint(with: self.view, margin: 4)
        let constaint = [
            tableView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constaint)
    }
}

