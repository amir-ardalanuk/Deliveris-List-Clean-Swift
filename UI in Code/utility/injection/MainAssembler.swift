//
//  MainAssembler.swift
//  AANetworkProvider
//
//  Created by Amir Ardalan on 4/26/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import NetworkPlatform
import RemotePlatform
import RepositroyPlatform
import StoragePlatform
import LocalPlatform

class MainAssembler {
    
    var resolver: Resolver {
        return assembler.resolver
    }
    
    let assembler = Assembler(container: SwinjectStoryboard.defaultContainer)
    
    init() {
        //Netowrk
        assembler.apply(assembly: URLSessionNetwork())
        assembler.apply(assembly: RequesterAssembly())
        assembler.apply(assembly: XMLRequesterAssembly())
        //Storage
        assembler.apply(assembly: UserDefaultStorageAssembly())
        //Local
        assembler.apply(assembly: LocalDeliveryUsecase())
        assembler.apply(assembly: LocalFavoriteUsecase())
        // Remote
        assembler.apply(assembly: RemoteFactoryAssembly())
        assembler.apply(assembly: RemoteNewsXMLUsecase())
        
        //Repository
        assembler.apply(assembly: RepositoryDeliveryUsecase())
        assembler.apply(assembly: RepositoryNewsXMLUsecase())
        
        //UI
        //assembler.apply(assembly: HomeRouterAssembly())
        assembler.apply(assembly: MainNavigationAssembly())
    }
}
