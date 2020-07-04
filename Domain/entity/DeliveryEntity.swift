//
//  DeliveryEntity.swift
//  Domain
//
//  Created by Amir Ardalan on 6/27/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
public struct DeliveryEntity: Codable {

   public let deliveryFee: String?
   public let goodsPicture: String?
   public let id: String?
   public let pickupTime: String?
   public let remarks: String?
   public let route: Route?
   public let sender: Sender?
   public let surcharge: String?
}

public struct Sender: Codable {

   public let email: String?
   public let name: String?
   public let phone: String?
}

public struct Route: Codable {

    public let end: String?
    public let start: String?
}
