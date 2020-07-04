//
//  DeliveryUsecaseImpl.swift
//  RepositroyPlatform
//
//  Created by Amir Ardalan on 6/27/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import RemotePlatform
import StoragePlatform
import Domain
import RxSwift
import Swinject
import LocalPlatform

public class DeliveryUsecaseImpl {
    let remote: RemotePlatform.DeliveryUsecaseImpl
    let local: LocalPlatform.LocalDeliveryUsecaseImpl
      //  let cache:StoragePlatform
    public init(remote: RemotePlatform.DeliveryUsecaseImpl, local: LocalPlatform.LocalDeliveryUsecaseImpl) {
            self.remote = remote
            self.local = local
        }
}

extension DeliveryUsecaseImpl: DeliveryUsecases {
    public func getDeliveryList() -> Observable<[DeliveryEntity]> {
        return  remote.getDeliveryList()
            .do(onNext: { (list) in
            self.local.saveDelivery(list)
            }).catchError { (_) -> Observable<[DeliveryEntity]> in
            return self.local.getDeliveryList()
        }
    }
}

public class RepositoryDeliveryUsecase: Assembly {
    public init() {
        
    }
    
    public func assemble(container: Container) {
        container.register(DeliveryUsecaseImpl.self) { (resolver) in
            let remote = resolver.resolve(RemoteFactory.self)
            let local = resolver.resolve(LocalDeliveryUsecaseImpl.self)
            return DeliveryUsecaseImpl(remote: remote!.deliveryUsecase(), local: local!)
        }.inObjectScope(.weak)
    }
}
