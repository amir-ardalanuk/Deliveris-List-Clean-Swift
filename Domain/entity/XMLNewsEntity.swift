//
//  XMLNewsEntity.swift
//  Domain
//
//  Created by Amir Ardalan on 6/30/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation

public struct XMLNewsEntity : Codable {
    public var channel:XMLNewsChannelEntity?
}


public struct XMLNewsChannelEntity:Codable {
   public var title:String?
   public var link:String?
   public var description:String?
   public var language:String?
   public var copyright:String?
   public var items: [RSSItem]

    enum CodingKeys: String, CodingKey {
        case items = "item"
    }
}

public struct RSSItem : Codable {
    var title:String?
    var description:String?
}
