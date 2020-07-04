//
//  RepositoryFactory.swift
//  RepositroyPlatform
//
//  Created by Amir Ardalan on 6/27/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import RemotePlatform
import LocalPlatform
import Swinject

public class RepositoryFactory {
    func deliveryRepository(remote: RemotePlatform.DeliveryUsecaseImpl, local: LocalDeliveryUsecaseImpl) -> DeliveryUsecaseImpl {
        return DeliveryUsecaseImpl(remote: remote, local: local)
    }
    func newsRepository(remote: RemotePlatform.NewsXMLUsecaseImpl) -> NewsXMLUsecaseImpl {
           return NewsXMLUsecaseImpl(remote: remote)
       }
}
