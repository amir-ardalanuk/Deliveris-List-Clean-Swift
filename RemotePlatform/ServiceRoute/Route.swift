//
//  Route.swift
//  Data
//
//  Created by Amir Ardalan on 5/4/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation

enum DeliveryRoutes: String, RouteFactoryMethod {

    case deliveryList = "/v2/deliveries"
    
    internal var baseUrl: String {
         get {
             return "https://mock-api-mobile.dev.lalamove.com"
         }
     }
    
    var route: RouteURL {
        return Route(endpoint: baseUrl + self.rawValue)
    }
    
}

enum Varzesh3: String, RouteFactoryMethod {
    internal var baseUrl: String {
        get {
            return "https://www.varzesh3.com/rss/"
        }
    }
    
    case iranNews = "domesticFootball"
    
    var route: RouteURL {
        return Route(endpoint: baseUrl + self.rawValue)
    }
}

enum FFIR: String, RouteFactoryMethod {
    internal var baseUrl: String {
        get {
            return "http://ffiri.ir/fa/rss/"
        }
    }
    
    case allNews = "allnews"
    
    var route: RouteURL {
        return Route(endpoint: baseUrl + self.rawValue)
    }
}
