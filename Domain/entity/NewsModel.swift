//
//  NewsModel.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/30/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
public struct NewsModel: Codable {
    
    public init(title: String?, date: String?, link: String?, desc: String?, imagePath: String?, isFavorite: Bool) {
        self.title = title
        self.date = date
        self.link = link
        self.desc = desc
        self.imagePath = imagePath
        self.isFavorite = isFavorite
    }
    public var title: String?
    public var date: String?
    public var link: String?
    public var desc: String?
    public var imagePath: String?
    public var isFavorite: Bool
    
    public func toggleFavoriteState() -> NewsModel {
        
        return NewsModel(title: self.title, date: self.date, link: self.link, desc: self.desc, imagePath: self.imagePath, isFavorite: !self.isFavorite)
    }
    
}
