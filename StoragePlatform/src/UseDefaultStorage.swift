//
//  UseDefaultStorage.swift
//  StoragePlatform
//
//  Created by Amir Ardalan on 6/28/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import RxSwift
import Swinject

open class UserDefaultStorage: StorageUsecase {
    
    public var keyUpdated = PublishSubject<String>()
    
    public init() {
        
    }
    
    public func retrive<T>(key: String, type: T.Type) -> Observable<T?> where T: Decodable, T: Encodable {
        Observable.create { (observer) -> Disposable in
            
            if let data = UserDefaults.standard.value(forKey: key) as? Data,
                let dataModel = try? JSONDecoder().decode(T.self, from: data) {
                observer.onNext(dataModel)
            }
            observer.onNext(nil)
            
            return Disposables.create {}
        }
    }
    
    public func save<T>(key: String, value: T) where T: Decodable, T: Encodable {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    public func retrive<T>(key: String, type: T.Type) -> T? where T: Decodable, T: Encodable {
        if let data = UserDefaults.standard.value(forKey: key) as? Data,
            let dataModel = try? JSONDecoder().decode(T.self, from: data) {
            return  dataModel
        }
        return nil
    }
    
    public func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
  
    public func updatedStatus(key: String) {
        keyUpdated.onNext(key)
    }
    
    public func statusChanged() -> Observable<String> {
        return keyUpdated.asObservable()
    }
    
}
open class UserDefaultStorageAssembly: Assembly {
    public init() {}
    public func assemble(container: Container) {
        container.register(UserDefaultStorage.self) { (_) in
            return UserDefaultStorage()
        }.inObjectScope(.weak)
    }
}
