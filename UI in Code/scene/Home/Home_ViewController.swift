//
//  HomeViewController.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/23/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    let getDerliveryList = PublishSubject<Void>()
    let bag = DisposeBag()
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
    
    var datasource = DeliveryDatasource()
    var viewModel: HomeViewModel!
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//LifeCycle
extension HomeViewController {
    
    override func loadView() {
        super.loadView()
        makeTableViewConstaint()
        tableViewConfig()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingBar.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.dataBinding()
        self.getDerliveryList.onNext(())
        self.title = "Delivery"
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.getDerliveryList.onNext(())
    }
}

// UI
extension HomeViewController {
    
    func tableViewConfig() {
        tableView.delegate = datasource
        tableView.dataSource = datasource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(DeliveryCell.self, forCellReuseIdentifier: "DeliveryCell")
        tableView.addSubview(self.loadingBar)
        tableView.reloadData()
    }
    
    func makeTableViewConstaint() {
        self.view.addSubview(tableView)
        tableView.activateFillSafeAreaConstraint(with: self.view, margin: 0)
    }
}

//Data Binding
extension HomeViewController {
    
    func dataBinding() {
        let input = HomeViewModel.Input(
            getList: getDerliveryList.asDriverOnErrorJustComplete(),
            selectedItem: tableView.rx.itemSelected.asDriver())
        
        let output = self.viewModel.transform(input: input)
        output.list.drive(tableView.rx.homeDataSourceList).disposed(by: bag)
        output.loading.drive(self.loadingBar.rx.isRefreshing).disposed(by: bag)
        
    }
}
extension Reactive where Base: UITableView {
    internal var homeDataSourceList: Binder<[DeliveryModel]> {
        return Binder(self.base, binding: { (view, data) in
            if let datasource = view.dataSource as? DeliveryDatasource {
                datasource.update(data)
                DispatchQueue.main.async {
                    view.reloadData {
                        print("reload")
                    }
                }
            }
        })
    }
}
