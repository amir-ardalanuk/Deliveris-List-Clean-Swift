//
//  NewsXMLRequestUsecase.swift
//  Domain
//
//  Created by Amir Ardalan on 6/30/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import RxSwift

public protocol NewsXMLUsecase {
    func getXMLVarzesh3Request()-> Observable<XMLVerzesh3Entity>
    func getXMLFFIRequest()-> Observable<XMLFFIREntity>
}
