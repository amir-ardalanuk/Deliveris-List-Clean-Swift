//
//  NewsTabVC.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/30/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsFeedVC: UIViewController {
    
    let bag = DisposeBag()
    var viewModel: NewsFeedVM!
    let datasource = NewsDataSource()
    let getDerliveryList = PublishSubject<Void>()
    
    let section: UISegmentedControl = {
        let sg = UISegmentedControl()
        sg.backgroundColor = .white
        sg.tintColor = .darkGray
        sg.translatesAutoresizingMaskIntoConstraints = false
        sg.insertSegment(withTitle: "Varzesh3", at: 0, animated: true)
        sg.insertSegment(withTitle: "Footbali", at: 1, animated: true)
        return sg
    }()
    
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
    
    init(viewModel: NewsFeedVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension NewsFeedVC {
    
    override func loadView() {
        super.loadView()
        tableViewConfig()
        makeTableViewConstaint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingBar.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.dataBinding()
        self.getDerliveryList.onNext(())
        self.title = "Delivery"
        self.view.backgroundColor = .white
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.getDerliveryList.onNext(())
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
extension NewsFeedVC {
    
    func dataBinding() {
        let input = NewsFeedVM.Input(
            getList: getDerliveryList.asDriverOnErrorJustComplete(),
            selectedItem: tableView.rx.itemSelected.asDriver())
        
        let output = self.viewModel.transform(input: input)
        output.list.drive(tableView.rx.newsDataSourceList).disposed(by: bag)
        output.loading.drive(self.loadingBar.rx.isRefreshing).disposed(by: bag)
        
    }
}

//Constraint
extension NewsFeedVC {
    
    func makeTableViewConstaint() {
        let mainStack = ViewMaker.makeStackView(axios: .vertical, distribution: .fill, aligment: .center, space: 8)
        self.view.addSubview(mainStack)
        
        mainStack.addArrangedSubview(section)
        mainStack.addArrangedSubview(tableView)
        
        mainStack.activateFillSafeAreaConstraint(with: self.view, margin: 4)
        let constaint = [
            section.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -8),
            section.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constaint)
    }
}

extension Reactive where Base: UITableView {
    internal var newsDataSourceList: Binder<[NewsModel]> {
        return Binder(self.base, binding: { (view, data) in
            if let datasource = view.dataSource as? NewsDataSource {
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
