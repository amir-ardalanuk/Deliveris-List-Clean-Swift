//
//  DeliveryDetail_Router.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/28/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import Domain


protocol DeliveryDetailNavigation {
    func deliveryDetail(_ delivery: DeliveryEntity,_ favoriteUsecase:FavoriteUsecase)
}

class DefaultDeliveryDetailNavigation: DeliveryDetailNavigation {
    
    let navigation : UINavigationController!
    
    init(navigation:UINavigationController) {
        self.navigation = navigation
    }
    
    func deliveryDetail(_ delivery: DeliveryEntity,_ favoriteUsecase:FavoriteUsecase) {
        let viewModel = DeliveryDetailViewModel(navigation: self, favoriteServices: favoriteUsecase, deliveryItem: delivery)
        let detail = DeliveryDetailViewController(viewModel: viewModel)
    self.navigation.pushViewController(detail, animated: true)
       }
       
}
