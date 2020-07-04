//
//  XMLNewsEntity.swift
//  Domain
//
//  Created by Amir Ardalan on 6/30/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation

public struct XMLVerzesh3Entity: Codable {
    public var channel: XMLNewsChannelEntity<RSSItem>?
}

public struct RSSItem: Codable {
    public var title: String?
    public var description: String?
    public var link: String?
    public var pubDate: String?
}
