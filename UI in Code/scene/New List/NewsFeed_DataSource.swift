//
//  DeliveryDataSource.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/23/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Domain

class NewsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var list: [NewsModel] = [NewsModel]()
    public var selectItem = BehaviorSubject<IndexPath?>(value: nil)
    public var favoriteSelected = PublishSubject<String>()
    private let bag = DisposeBag()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func update(_ list: [NewsModel]) {
        self.list = list
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NewsCell(style: .default, reuseIdentifier: "NewsCell")
        cell.config(model: list[indexPath.row]).bind(to: self.favoriteSelected).disposed(by: bag)
        return cell
    }
}

extension Reactive where Base: NewsDataSource {
    internal var newsDataSourceList: Binder<[NewsModel]> {
        return Binder(self.base, binding: { (view, data) in
            view.update(data)
        })
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
