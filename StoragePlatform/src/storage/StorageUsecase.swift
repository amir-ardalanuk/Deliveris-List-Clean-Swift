//
//  StorageUsecase.swift
//  StoragePlatform
//
//  Created by Amir Ardalan on 6/28/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import RxSwift

public protocol StorageUsecase {
    func save<T: Codable>(key: String, value: T)
    func remove(key: String)
    func retrive<T: Codable>(key: String, type: T.Type) -> T?
    func updatedStatus(key: String)
    func statusChanged() -> Observable<String>
}
