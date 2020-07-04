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

class NewsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var list: [NewsModel] = [NewsModel]()
    public var selectItem = BehaviorSubject<IndexPath?>(value: nil)

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func update(_ list: [NewsModel]) {
        self.list = list
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NewsCell(style: .default, reuseIdentifier: "NewsCell")
        cell.config(model: list[indexPath.row])
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
