//
//  XMLNewsChannelEntity.swift
//  Domain
//
//  Created by Amir Ardalan on 7/4/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation

public struct XMLNewsChannelEntity<T: Codable>: Codable {
   public var title: String?
   public var link: String?
   public var description: String?
   public var language: String?
   public var copyright: String?
   public var items: [T]

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case link = "link"
        case description = "description"
        case language = "language"
        case copyright = "copyright"
        case items = "item"
    }
}
