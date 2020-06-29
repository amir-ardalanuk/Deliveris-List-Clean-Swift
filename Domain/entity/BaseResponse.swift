//
//  BaseResponse.swift
//  Domain
//
//  Created by Amir Ardalan on 5/4/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
protocol BaseResponse :Codable {
    var status :Bool?{get set}
}

public class Response<T:Codable> : Codable {

    public let data : T?


}
