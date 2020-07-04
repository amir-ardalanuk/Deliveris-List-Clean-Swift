//
//  NewsModel.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/30/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
public struct NewsModel: Codable {
   public var title: String?
   public var date: String?
   public var link: String?
   public var desc: String?
   public var imagePath: String?
}
