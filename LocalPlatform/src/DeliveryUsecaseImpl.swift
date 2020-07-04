//
//  DeliveryUsecaseImpl.swift
//  LocalPlatform
//
//  Created by Amir Ardalan on 6/29/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import Domain
import StoragePlatform
import RxSwift
import Swinject

public class LocalDeliveryUsecaseImpl: DeliveryUsecases {
    let storage: StorageUsecase
    let deliveryKey = "DELIVERY_STORAGE"
    
    public init(storage: StorageUsecase) {
        self.storage = storage
    }
    
    public func getDeliveryList() -> Observable<[DeliveryEntity]> {
        let data = storage.retrive(key: deliveryKey, type: [DeliveryEntity].self)
        return Observable.from(optional: data)
    }
    //TODO Develop ExpireLocal,
}

extension Domain.DeliveryUsecases where Self == LocalDeliveryUsecaseImpl {
    public func saveDelivery(_ list: [DeliveryEntity]) {
        self.storage.save(key: self.deliveryKey, value: list)
    }
}

public class LocalDeliveryUsecase: Assembly {
    public init() {
        
    }
    
    public func assemble(container: Container) {
        container.register(LocalDeliveryUsecaseImpl.self) { (resolver) in
            let storage = resolver.resolve(UserDefaultStorage.self)
            return LocalDeliveryUsecaseImpl(storage: storage!)
        }.inObjectScope(.weak)
    }
}
