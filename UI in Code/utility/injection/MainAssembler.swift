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
    var resolver : Resolver {
        return assembler.resolver
    }
    
    let assembler = Assembler(container: SwinjectStoryboard.defaultContainer)
    
    init() {
        assembler.apply(assembly: URLSessionNetwork())
        assembler.apply(assembly: RequesterAssembly())
        assembler.apply(assembly: RemoteFactoryAssembly())
        assembler.apply(assembly: UserDefaultStorageAssembly())
        assembler.apply(assembly: LocalDeliveryUsecase())
        assembler.apply(assembly: LocalFavoriteUsecase())
        assembler.apply(assembly: RepositoryDeliveryUsecase())
        assembler.apply(assembly: MainNavigationAssembly())
        
        assembler.apply(assembly: HomeRouterAssembly())
    }
}
