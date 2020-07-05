//
//  XMLFFIREntity.swift
//  Domain
//
//  Created by Amir Ardalan on 7/4/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
public struct XMLFFIREntity: Codable {
    public var channel: XMLNewsChannelEntity<FFIRItemEntity>?
}

public struct FFIRItemEntity: Codable {
    public var title: String?
    public var description: String?
    public var link: String?
    public var pubDate: String?
    public var enclosure: EnclosureEntity?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case link
        case pubDate
        case enclosure
        
    }
}

public struct EnclosureEntity: Codable {
    public var url: String?
}
