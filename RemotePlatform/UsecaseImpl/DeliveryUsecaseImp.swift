//
//  DeliveryUsecaseImp.swift
//  RemotePlatform
//
//  Created by Amir Ardalan on 6/27/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import NetworkPlatform
import Domain
import RxSwift

public class DeliveryUsecaseImpl {
    let network: NetworkRequest
    
    public init(network: NetworkRequest) {
        self.network = network
    }
}

extension DeliveryUsecaseImpl: DeliveryUsecases {
    public func getDeliveryList() -> Observable<[DeliveryEntity]> {
        let provider = DefaultNetworkProvider.make(route: DeliveryRoutes.deliveryList.route.endpoint)
        return network.makeRXRequest(provider: provider, ofType: [DeliveryEntity].self).asObservable()
    }
}
