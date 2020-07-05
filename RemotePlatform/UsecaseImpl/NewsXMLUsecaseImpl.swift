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

public struct NewsXMLUsecaseImpl: Domain.NewsXMLUsecase {
 
    let requester: NetworkRequest
    init(requester: NetworkRequest) {
        self.requester = requester
    }
    
    public func getXMLVarzesh3Request() -> Observable<XMLVerzesh3Entity> {
        let provider = DefaultNetworkProvider.make(route: Varzesh3.iranNews.route.endpoint)
        return requester.makeRXRequest(provider: provider, ofType: XMLVerzesh3Entity.self).asObservable()
    }
    
    public func getXMLFFIRequest() -> Observable<XMLFFIREntity> {
          let provider = DefaultNetworkProvider.make(route: FFIR.allNews.route.endpoint)
            return requester.makeRXRequest(provider: provider, ofType: XMLFFIREntity.self).asObservable()
     }
     
}

public class RemoteNewsXMLUsecase: Assembly {
    
    public init() {
        
    }
    public func assemble(container: Container) {
        container.register(RemotePlatform.NewsXMLUsecaseImpl.self) { resolver in
            let network = resolver.resolve(Requester.self, name: XMLRequesterAssembly.name)
            return NewsXMLUsecaseImpl(requester: network!)
        }
    }
}
