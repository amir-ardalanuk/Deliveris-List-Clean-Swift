//
//  Route.swift
//  Data
//
//  Created by Amir Ardalan on 5/4/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation

enum deliveryRoutes :String, RouteFactoryMethod {

    case deliveryList = "/v2/deliveries"
    
    internal var baseUrl: String {
         get{
             return "https://mock-api-mobile.dev.lalamove.com"
         }
     }
    var route: RouteURL {
        return Route(endpoint: baseUrl + self.rawValue)
    }
    
}
