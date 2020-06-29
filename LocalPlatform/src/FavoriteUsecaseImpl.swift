//
//  FavoriteUsecaseImpl.swift
//  StoragePlatform
//
//  Created by Amir Ardalan on 6/28/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import StoragePlatform
import Swinject

public class FavoriteUsecaseImpl : Domain.FavoriteUsecase {
    
    let FAV_KEY = "FAV_ID"
    let storage : StorageUsecase
    
    init(storage:StorageUsecase) {
        self.storage = storage
    }
    
    public func addToFavorite(id: String) {
        var items = storage.retrive(key: FAV_KEY, type:[String].self) ?? []
        items.append(id)
        storage.save(key: FAV_KEY, value: items)
        storage.updatedStatus(key: FAV_KEY)
    }
    
    public func isFavorite(_ id: String) -> Observable<Bool> {
        let items = storage.retrive(key: FAV_KEY, type:[String].self) ?? []
        return Observable.from(optional: items.filter{ $0 == id}.first != nil)
    }
    
    public func retriveFavoritesIds() -> Observable<[String]> {
        let items = storage.retrive(key: FAV_KEY, type:[String].self) ?? []
        return Observable.from(optional: items )
    }
    
    public func removeFromFavorite(id: String) {
        var items = storage.retrive(key: FAV_KEY, type:[String].self) ?? []
        let idx = items.firstIndex{ $0 == id}
        guard let index = idx else {return}
        items.remove(at: index)
        storage.save(key: FAV_KEY, value: items)
        storage.updatedStatus(key: FAV_KEY)
    }
    
    public func changeStorageState() -> Observable<String> {
        return storage.statusChanged().filter{$0 == self.FAV_KEY}
    }
    
    
    
}

public class LocalFavoriteUsecase:Assembly {
    public init(){}
    public func assemble(container: Container) {
        container.register(FavoriteUsecaseImpl.self) { (r) in
            let storage = r.resolve(UserDefaultStorage.self)
            return FavoriteUsecaseImpl(storage: storage!)
        }.inObjectScope(.weak)
    }
}
