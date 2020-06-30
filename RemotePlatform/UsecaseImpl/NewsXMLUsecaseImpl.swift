//
//  BusinessNewsUsecase.swift
//  RemotePlatform
//
//  Created by Amir Ardalan on 6/30/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import RxSwift
import Swinject

public struct NewsXMLUsecaseImpl : Domain.NewsXMLUsecase {
    
    let requester : NetworkRequest
    init(requester:NetworkRequest) {
        self.requester = requester
    }
    
    public func getNewsXMLRequest() -> Observable<XMLNewsEntity> {
        let provider = DefaultNetworkProvider.make(route: TCETMCRout.codal.route.endpoint)
        return requester.makeRXRequest(provider: provider, ofType: XMLNewsEntity.self).asObservable()
    }
}

public class RepositoryNewsXMLUsecase:Assembly{
    public init(){}
    public func assemble(container: Container) {
        container.register(NewsXMLUsecaseImpl.self){ r in
            let network = r.resolve(Requester.self, name: XMLRequesterAssembly.name)
            return NewsXMLUsecaseImpl(requester:network!)
        }
    }
    
    
}
