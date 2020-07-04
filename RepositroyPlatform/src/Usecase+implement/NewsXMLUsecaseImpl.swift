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

public class NewsXMLUsecaseImpl {
    
    let remote: RemotePlatform.NewsXMLUsecaseImpl
    public init(remote: RemotePlatform.NewsXMLUsecaseImpl) {
            self.remote = remote
    }
}

extension NewsXMLUsecaseImpl: Domain.NewsXMLUsecase {
    public func getXMLFFIRequest() -> Observable<XMLFFIREntity> {
        return remote.getXMLFFIRequest()
    }
    
    public func getXMLVarzesh3Request() -> Observable<XMLVerzesh3Entity> {
        return remote.getXMLVarzesh3Request()
    }
}
public class RepositoryNewsXMLUsecase: Assembly {
    public init() {
        
    }
    public func assemble(container: Container) {
        container.register(NewsXMLUsecaseImpl.self) { (resolver) in
            let remote = resolver.resolve(RemotePlatform.NewsXMLUsecaseImpl.self)
            
            return NewsXMLUsecaseImpl(remote: remote!)
        }.inObjectScope(.weak)
    }
}
