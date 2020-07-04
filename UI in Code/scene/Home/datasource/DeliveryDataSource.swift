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

class DeliveryDatasource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var list: [DeliveryModel] = [DeliveryModel]()
    public var selectItem = BehaviorSubject<IndexPath?>(value: nil)

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func update(_ list: [DeliveryModel]) {
        self.list = list
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DeliveryCell(style: .default, reuseIdentifier: "DeliveryCell")
        cell.config(data: list[indexPath.row])
        return cell
    }
}

extension Reactive where Base: DeliveryDatasource {
    internal var homeDataSourceList: Binder<[DeliveryModel]> {
        return Binder(self.base, binding: { (view, data) in
            view.update(data)
        })
    }
}
