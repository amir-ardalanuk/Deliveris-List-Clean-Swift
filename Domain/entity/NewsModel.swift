//
//  NewsModel.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/30/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
public struct NewsModel: Codable {
    
    public init(title: String?, date: String?, link: String?, desc: String?, imagePath: String?) {
        self.title = title
        self.date = date
        self.link = link
        self.desc = desc
        self.imagePath = imagePath
    }
    public var title: String?
    public var date: String?
    public var link: String?
    public var desc: String?
    public var imagePath: String?
}
