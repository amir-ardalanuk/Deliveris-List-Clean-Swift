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

public class FavoriteUsecaseImpl: Domain.FavoriteUsecase {
    
    let favKey = "FAV_ID"
    let storage: StorageUsecase
    
    init(storage: StorageUsecase) {
        self.storage = storage
    }
    
    public func addToFavorite(id key: String) {
        var items = storage.retrive(key: favKey, type: [String].self) ?? []
        items.append(key)
        storage.save(key: favKey, value: items)
        storage.updatedStatus(key: favKey)
    }
    
    public func isFavorite(_ key: String) -> Observable<Bool> {
        let items = storage.retrive(key: favKey, type: [String].self) ?? []
        return Observable.from(optional: items.filter { $0 == key}.first != nil)
    }
    
    public func retriveFavoritesIds() -> Observable<[String]> {
        let items = storage.retrive(key: favKey, type: [String].self) ?? []
        return Observable.from(optional: items )
    }
    
    public func removeFromFavorite(id key: String) {
        var items = storage.retrive(key: favKey, type: [String].self) ?? []
        let idx = items.firstIndex { $0 == key}
        guard let index = idx else {return}
        items.remove(at: index)
        storage.save(key: favKey, value: items)
        storage.updatedStatus(key: favKey)
    }
    
    public func changeStorageState() -> Observable<String> {
        return storage.statusChanged().filter { $0 == self.favKey }
    }
}

public class LocalFavoriteUsecase: Assembly {
    public init() {
        
    }
    
    public func assemble(container: Container) {
        container.register(FavoriteUsecaseImpl.self) { (resolver) in
            let storage = resolver.resolve(UserDefaultStorage.self)
            return FavoriteUsecaseImpl(storage: storage!)
        }.inObjectScope(.weak)
    }
}
