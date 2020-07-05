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
    
    public func isFavorite(_ key: String) -> Observable<Bool> {
        let items = storage.retrive(key: favKey, type: [NewsModel].self) ?? []
        return Observable.from(optional: items.filter { ($0.link ?? "") == key}.first != nil)
    }
    
    public func addToFavorite(news: NewsModel) {
        var items = storage.retrive(key: favKey, type: [NewsModel].self) ?? []
        items.append(news)
        storage.save(key: favKey, value: items)
        storage.updatedStatus(key: favKey)
    }
    
    public func removeFromFavorite(news: NewsModel) {
        var items = storage.retrive(key: favKey, type: [NewsModel].self) ?? []
        let idx = items.firstIndex { $0.link == news.link}
        guard let index = idx else {return}
        items.remove(at: index)
        storage.save(key: favKey, value: items)
        storage.updatedStatus(key: favKey)
    }
    
    public func retriveFavoritesModels() -> Observable<[NewsModel]> {
        let items = storage.retrive(key: favKey, type: [NewsModel].self) ?? []
        return Observable.from(optional: items )
    }
    
    public func changeStorageState() -> Observable<String> {
        return storage.statusChanged().filter { $0 == self.favKey }
    }
    
    public func toggle(model: NewsModel) -> Observable<Bool> {
        return isFavorite(model.link ?? "").do(onNext: { (state) in
            if state {
                self.removeFromFavorite(news: model)
            } else {
                self.addToFavorite(news: model)
            }
        })
        
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
